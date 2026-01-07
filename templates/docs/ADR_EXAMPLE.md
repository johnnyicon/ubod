# Use PostgreSQL HNSW for Vector Similarity Search

**Date:** 2026-01-07
**Status:** Accepted
**Deciders:** Engineering Team
**Related PRD:** PRD-05: RAG Foundation
**Supersedes:** None

---

## Context and Problem Statement

Our RAG system needs to perform similarity search on document embeddings to retrieve relevant context for user queries. We currently have 50,000+ documents with 1536-dimensional embeddings (OpenAI ada-002), and expect to scale to 1M+ documents within 6 months.

Linear scan (comparing query embedding to all document embeddings) is taking 3+ seconds per query with our current dataset. This is unacceptable for user experience—we need sub-100ms query times.

We need to choose a vector indexing solution that balances query performance, cost, and maintenance burden.

---

## Decision Drivers

* **Query performance:** Target < 100ms for 1M vectors (95th percentile)
* **Cost optimization:** Minimize cloud infrastructure spend (budget: $500/mo)
* **Maintenance burden:** Prefer solutions requiring minimal operational overhead
* **Data locality:** Keep vector data close to relational data (avoid network hops)
* **Dynamic dataset:** Data changes frequently (new documents, re-indexing)
* **Team expertise:** Team is familiar with PostgreSQL, no specialized vector DB experience

---

## Considered Options

* Option 1: PostgreSQL pgvector with HNSW indexing
* Option 2: Pinecone managed vector database
* Option 3: Elasticsearch with dense_vector type

---

## Decision Outcome

**Chosen:** PostgreSQL pgvector with HNSW indexing

**Rationale:** HNSW provides 15x faster similarity search than linear scan, meets our < 100ms target, and eliminates external dependencies. Since we already use PostgreSQL 16 for relational data, this approach keeps vector data co-located with document metadata, avoiding network hops and simplifying joins. Cost is $0 beyond existing database infrastructure (vs $70+/mo for Pinecone).

**Key Trade-offs Accepted:**
* **Gained:** No external dependency, lower cost, better data locality, simpler architecture
* **Lost:** Less specialized features than dedicated vector databases (no built-in A/B testing, no managed scaling beyond PostgreSQL capabilities)

---

## Consequences

### Positive

* **15x performance improvement:** Query time reduced from 3+ seconds to ~80ms (95th percentile)
* **Zero additional cost:** No monthly subscription fees
* **Better data locality:** Vector data co-located with relational data (faster joins)
* **Simpler architecture:** One less external service to maintain
* **Dynamic indexing:** HNSW doesn't require training step (unlike IVFFlat)

### Negative

* **Self-managed indexing:** We're responsible for index tuning and maintenance
* **PostgreSQL scaling limits:** Limited by PostgreSQL capabilities (not infinite scale like managed services)
* **Feature limitations:** Missing specialized vector DB features (built-in relevance tuning, A/B testing)

### Neutral

* **Requires PostgreSQL 16+:** Infrastructure upgrade needed (already planned)
* **Team learning curve:** Need to learn pgvector extension and HNSW parameters

---

## Pros and Cons of the Options

### Option 1: PostgreSQL pgvector with HNSW

**Approach:** Use PostgreSQL extension with HNSW (Hierarchical Navigable Small World) indexing for approximate nearest neighbor search.

**Pros:**
* No external dependency or monthly cost
* Data co-located with relational data (better joins)
* HNSW doesn't require training step (dynamic dataset friendly)
* Team already familiar with PostgreSQL
* 15x faster than linear scan

**Cons:**
* Need to manage indexing and tuning ourselves
* Limited to PostgreSQL scaling capabilities
* Missing specialized vector DB features (A/B testing, relevance tuning)
* Requires PostgreSQL 16+ (infrastructure upgrade)

**Estimated Effort:** Medium (1-2 days for migration + tuning)

---

### Option 2: Pinecone managed vector database

**Approach:** Use Pinecone's managed vector database service with their proprietary indexing.

**Pros:**
* Specialized vector database (optimized for similarity search)
* Managed service (no operational burden)
* Built-in features (A/B testing, relevance tuning, monitoring)
* Infinite scale (handles millions of vectors easily)
* Fast setup (API-driven, minimal configuration)

**Cons:**
* Monthly cost: $70+ (starter plan) scaling with usage
* External dependency (network latency for queries)
* Data not co-located with relational data (complex joins)
* Vendor lock-in (proprietary API)
* Team needs to learn new service

**Estimated Effort:** Small (< 1 day for integration)

---

### Option 3: Elasticsearch with dense_vector type

**Approach:** Use Elasticsearch's vector search capabilities with dense_vector field type.

**Pros:**
* Already using Elasticsearch for full-text search (existing infrastructure)
* Combines full-text and vector search in one query
* Good for hybrid search use cases
* Managed service available (Elastic Cloud)

**Cons:**
* Elasticsearch vector search is slower than specialized solutions (2-3x slower than HNSW)
* Higher cost than PostgreSQL (resource-intensive)
* Overkill if only need vector search (not using full-text features)
* Additional operational complexity (another service to maintain)

**Estimated Effort:** Medium (2-3 days for integration and tuning)

---

## Implementation Notes

**Key Files:**
* `db/migrate/20260107_add_vector_index.rb` - Migration to add HNSW index
* `app/models/doc_version.rb` - Model with vector search methods
* `config/database.yml` - PostgreSQL 16 configuration
* `Gemfile` - Added neighbor gem for pgvector support

**Verification:**
```bash
# Check HNSW index exists
cd apps/tala && bin/rails runner "puts DocVersion.connection.execute('SELECT indexname FROM pg_indexes WHERE indexname LIKE \'%hnsw%\';').values"

# Run performance test
cd apps/tala && bin/rails test test/models/doc_version_test.rb::test_vector_search_performance

# Expected: Query time < 100ms for 50k vectors
```

**Rollback Plan:**
```sql
-- If HNSW doesn't work, revert to IVFFlat (requires training but simpler)
DROP INDEX IF EXISTS doc_versions_summary_embedding_idx;
CREATE INDEX doc_versions_summary_embedding_idx ON doc_versions 
  USING ivfflat (summary_embedding vector_cosine_ops) 
  WITH (lists = 100);
```

---

## More Information

* **PRD:** [PRD-05: RAG Foundation](../../prds/tala/mvp/PRD_05_RAG_FOUNDATION_AND_AI_SETTINGS.md)
* **Discussion:** [GitHub Issue #42: Vector search performance](https://github.com/org/repo/issues/42)
* **Commits:** 
  - [abc123](https://github.com/org/repo/commit/abc123) - Add HNSW index migration
  - [def456](https://github.com/org/repo/commit/def456) - Implement vector search in DocVersion model
* **External References:**
  - [PostgreSQL pgvector documentation](https://github.com/pgvector/pgvector)
  - [HNSW vs IVFFlat comparison](https://supabase.com/blog/increase-performance-pgvector-hnsw)
  - [pgvector performance benchmarks](https://github.com/pgvector/pgvector-python/blob/master/benchmarks/RESULTS.md)

---

## Addendum

### 2026-01-15 - Index Parameters Tuning

After deploying to production with 100k documents, we tuned HNSW parameters for better recall/performance balance:

**Changes:**
- Increased `m` from 16 to 24 (more connections per node)
- Increased `ef_construction` from 64 to 100 (better index quality)
- Set `ef_search` to 40 for queries (runtime search depth)

**Impact:**
- Query time increased slightly: 80ms → 95ms (still within target)
- Recall improved: 0.92 → 0.97 (finding more relevant results)
- Index build time increased: 5min → 12min (acceptable for batch operations)

**New Trade-offs:** Accepted 15ms slower queries for 5% better recall (user experience improvement).

**No superseding needed:** Original decision remains valid, just parameter optimization.

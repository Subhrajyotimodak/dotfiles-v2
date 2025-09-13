local vectorcode_ok, vectorcode = pcall(require, "vectorcode")
if not vectorcode_ok then
	vim.notify("vectorcode not installed")
	return
end
-- Configure VectorCode for semantic code search
vectorcode.setup({
	-- Embedding model configuration
	embedding = {
		provider = "openai", -- or "local" for offline embeddings
		model = "text-embedding-3-small", -- Cost-effective OpenAI embedding model
		api_key_name = "OPENAI_API_KEY", -- Can use separate key for embeddings
		batch_size = 100, -- Process embeddings in batches
		max_tokens = 8192, -- Maximum tokens per embedding
	},

	-- Vector database configuration
	database = {
		path = vim.fn.stdpath("data") .. "/vectorcode", -- Local vector database
		dimension = 1536, -- text-embedding-3-small dimensions
		similarity_threshold = 0.7, -- Minimum similarity for retrieval
		max_results = 10, -- Maximum results to retrieve
	},

	-- Indexing configuration
	indexing = {
		auto_index = true, -- Automatically index files on save
		file_types = { "lua", "python", "javascript", "typescript", "rust", "go", "java", "cpp", "c" },
		ignore_patterns = { "node_modules", ".git", "__pycache__", "target", "build" },
		chunk_size = 1000, -- Size of code chunks for embedding
		chunk_overlap = 200, -- Overlap between chunks
	},

	-- RAG configuration
	retrieval = {
		enabled = true, -- Enable RAG for Avante
		context_window = 4000, -- Maximum context from RAG
		rerank = true, -- Re-rank results by relevance
		include_metadata = true, -- Include file paths and line numbers
	},
})

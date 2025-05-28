import os
from langchain_core.documents import Document
from langchain_experimental.graph_transformers.llm import LLMGraphTransformer
from langchain_community.graphs import Neo4jGraph
from dotenv import load_dotenv
from langchain_openai import ChatOpenAI

# --- Load environment variables from the project root .env.local ---
project_root = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..', '..', '..'))
dotenv_path_calculated = os.path.join(project_root, '.env.local')
print(f"Attempting to load .env.local from: {dotenv_path_calculated}")
load_dotenv(dotenv_path=dotenv_path_calculated)

# --- Debugging check for loaded environment variables ---
print(f"OPENROUTER_API_KEY loaded: {'*****' if os.getenv('OPENROUTER_API_KEY') else 'NOT FOUND or EMPTY'}")
print(f"OPENROUTER_API_BASE loaded: {os.getenv('OPENROUTER_API_BASE')}")
# --- End Debugging check ---

# --- Configuration ---
DATA_DIR = "descriptions" # This path is correct relative to kg_builder.py

# Neo4j Connection Details
NEO4J_URI = os.getenv("NEO4J_URI")
NEO4J_USERNAME = os.getenv("NEO4J_USERNAME")
NEO4J_PASSWORD = os.getenv("NEO4J_PASSWORD")
NEO4J_DATABASE = os.getenv("NEO4J_DATABASE", "neo4j")

# LLM Configuration for Graph Extraction (Mistral via OpenRouter)
os.environ["OPENAI_API_KEY"] = os.getenv("OPENROUTER_API_KEY")
OPENROUTER_BASE_URL = os.getenv("OPENROUTER_API_BASE", "https://openrouter.ai/api/v1")
LLM_MODEL_FOR_EXTRACTION = "mistralai/mistral-7b-instruct" # Or "mistralai/mixtral-8x7b-instruct-v0.1" if you prefer

# --- Check for critical environment variables ---
if os.getenv("OPENROUTER_API_KEY") is None:
    print("Error: OPENROUTER_API_KEY is not found in .env.local or is empty. Please check your .env.local file.")
    exit(1)
if os.getenv("OPENROUTER_API_BASE") is None:
    print("Error: OPENROUTER_API_BASE is not found in .env.local or is empty. Please ensure it's set to 'https://openrouter.ai/api/v1'.")
    exit(1)


# --- 1. Define Knowledge Graph Schema (Nodes and Relationships) ---
ALLOWED_NODES = [
    "Person", "Project", "Skill", "Technology", "Company", "Role", "Date",
    "Interest", "Value", "Aspiration", "Education", "Degree", "Course", "Award",
    "Location", "Institution", "Specialization"
]

ALLOWED_RELATIONSHIPS = [
    "WORKS_ON",
    "USES",
    "APPLIES",
    "HAS_SKILL",
    "WORKED_AT",
    "HAS_ROLE",
    "AT_COMPANY",
    "STARTED_ON",
    "ENDED_ON",
    "RELATED_TO",
    "HAS_INTEREST",
    "EMBRACES",
    "ASPIRES_TO",
    "STUDIED_AT",
    "EARNED_DEGREE",
    "HAS_SPECIALIZATION",
    "TOOK_COURSE",
    "RECEIVED_AWARD",
    "LOCATED_AT",
    "DEMONSTRATES"
]

# --- 2. Load Portfolio Data from Files ---
def load_portfolio_data(data_dir: str) -> list[Document]:
    """
    Loads text content from all .txt and .md files in the specified directory
    into LangChain Document objects.
    """
    documents = []
    data_full_path = os.path.join(os.path.dirname(__file__), data_dir)
    print(f"Loading data from: {data_full_path}")
    if not os.path.exists(data_full_path):
        print(f"Error: Data directory '{data_full_path}' not found. Please create it and add your .md files.")
        return []

    for filename in os.listdir(data_full_path):
        if filename.endswith((".txt", ".md")):
            filepath = os.path.join(data_full_path, filename)
            try:
                with open(filepath, 'r', encoding='utf-8') as f:
                    content = f.read()
                    documents.append(Document(page_content=content, metadata={"source": filename}))
                    print(f"Loaded: {filename}")
            except Exception as e:
                print(f"Error reading {filename}: {e}")
    return documents

# --- 3. Initialize LLM for Graph Extraction and Graph Transformer ---
def get_llm_for_extraction():
    """
    Initializes and returns the ChatOpenAI LLM configured to use OpenRouter.
    """
    return ChatOpenAI(
        temperature=0, # Low temperature for factual extraction
        model=LLM_MODEL_FOR_EXTRACTION,
        base_url=OPENROUTER_BASE_URL, # Explicitly set base_url for OpenRouter
        max_tokens=16384 # <--- ADD THIS LINE: Allow for a larger output response
    )

def create_graph_transformer(llm_instance):
    """
    Creates an LLMGraphTransformer instance with the defined schema.
    This transformer uses the LLM to parse text into graph structures.
    """
    return LLMGraphTransformer(
        llm=llm_instance, # Fixed typo here: was lll_instance
        allowed_nodes=ALLOWED_NODES,
        allowed_relationships=ALLOWED_RELATIONSHIPS
    )

# --- 4. Connect to Neo4j Graph Database ---
def connect_to_neo4j():
    """
    Establishes connection to Neo4j using credentials from .env.local
    and performs a test query to confirm connectivity.
    """
    if not all([NEO4J_URI, NEO4J_USERNAME, NEO4J_PASSWORD]):
        print("Error: Neo4j credentials (URI, Username, Password) are not fully set in .env.local.")
        exit(1)

    graph = Neo4jGraph(
        url=NEO4J_URI,
        username=NEO4J_USERNAME,
        password=NEO4J_PASSWORD,
        database=NEO4J_DATABASE
    )
    try:
        # A simple query to check if the connection is active
        graph.query("CALL db.labels()")
        print("Successfully connected to Neo4j.")
    except Exception as e:
        print(f"Failed to connect to Neo4j: {e}")
        print(f"Please ensure your Neo4j instance is running and credentials in .env.local are correct.")
        print(f"Attempted URI: {NEO4J_URI}, Username: {NEO4J_USERNAME}")
        print(f"If using AuraDB, ensure it's RUNNING in your console.")
        print(f"If local, ensure Docker container/Desktop app is running and accessible.")
        exit(1)
    return graph

# --- Main Execution Flow ---
if __name__ == "__main__":
    print("Starting Knowledge Graph creation process...")

    # Step 2: Load portfolio data from your .md files
    portfolio_documents = load_portfolio_data(DATA_DIR)
    if not portfolio_documents:
        print("Exiting: No documents found to process.")
        exit()

    # Step 3: Initialize LLM and Graph Transformer for extraction
    llm_for_extraction = get_llm_for_extraction()
    llm_transformer = create_graph_transformer(llm_for_extraction)

    # Step 4: Connect to Neo4j database
    graph_db = connect_to_neo4j()

    # Optional: Clear existing graph data for a fresh start
    # BE CAREFUL: This will delete ALL data in the connected Neo4j database.
    print("Clearing existing graph data in Neo4j for a fresh start...")
    graph_db.query("MATCH (n) DETACH DELETE n")
    print("Previous graph data cleared.")

    # Step 5: Extract graph documents using the LLM
    print("Extracting graph documents from text using LLM (via OpenRouter)... This may take a moment.")
    graph_documents = llm_transformer.convert_to_graph_documents(portfolio_documents)

    print(f"Extracted {len(graph_documents)} graph documents.")
    for i, g_doc in enumerate(graph_documents):
        source_file = g_doc.source.metadata.get('source', 'N/A')
        print(f"\n--- Extracted from {source_file} (Document {i+1}) ---")
        # Corrected print statement for nodes:
        # Outermost: triple double quotes """
        # Inner f-string for list comprehension elements: f"..."
        # String literal in .get(): 'name' (single quotes)
        print(f"""  Nodes ({len(g_doc.nodes)}): {[f"{node.properties.get('name', node.id)} ({node.type})" for node in g_doc.nodes]}""")
        # Corrected print statement for relationships:
        # Outermost: triple double quotes """
        # Inner f-string for list comprehension elements: f"..."
        # String literal in .get(): 'name' (single quotes)
        print(f"""  Relationships ({len(g_doc.relationships)}): {
            [f"{rel.source.properties.get('name', rel.source.id)} ({rel.source.type}) -[{rel.type}]-> "
             f"{rel.target.properties.get('name', rel.target.id)} ({rel.target.type})"
             for rel in g_doc.relationships]
        }""")

    # Step 6: Add the extracted graph documents to Neo4j
    print("\nAdding extracted graph documents to Neo4j...")
    graph_db.add_graph_documents(graph_documents)
    print("Knowledge Graph creation complete!")

    # print("\n--- IMPORTANT NEXT STEPS ---")
    # print(f"1. **Verify your graph:** Go to Neo4j Browser at {NEO4J_URI.replace('bolt://', 'http://').replace('7687', '7474')} (if local) or your AuraDB console.")
    # print("   - Run queries like: `MATCH (n) RETURN n LIMIT 100`, `MATCH (p:Person)-[r]-(o) RETURN p,r,o` to see your graph.")
    # print("   - Look for accuracy in extracted nodes and relationships. Correct any errors manually in Neo4j if needed.")
    # print("2. **Prepare for Vercel deployment:** Ensure the `NEO4J_URI`, `NEO4J_USERNAME`, `NEO4J_PASSWORD`, `NEO4J_DATABASE`, and `OPENROUTER_API_KEY` are set as Environment Variables in your Vercel project settings.")
    # print("   - Remember to use your **AuraDB URI** for Vercel, not `localhost`!")
    # print("3. **Integrate GraphRAG into your `route.ts`:** This is the next major coding step for your chatbot.")
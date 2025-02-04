from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from typing import Optional
import os

from supabase import create_client, Client
from langchain.agents import create_sql_agent
from langchain.agents.agent_toolkits import SQLDatabaseToolkit

from langchain.sql_database import SQLDatabase
from langchain.llms.openai import OpenAI
from langchain.agents import AgentExecutor
from dotenv import load_dotenv

load_dotenv()

app = FastAPI()

supabase: Client = create_client(
    os.environ.get("SUPABASE_URL"),
    os.environ.get("SUPABASE_SERVICE_KEY")
)

db = SQLDatabase.from_uri(os.environ.get("DATABASE_URL"))

llm = OpenAI(temperature=0)
toolkit = SQLDatabaseToolkit(db=db, llm=llm)

agent_executor = create_sql_agent(
    llm=llm,
    toolkit=toolkit,
    verbose=True,
    agent_type="zero-shot-react-description",
)

class ChatMessage(BaseModel):
    message: str

@app.post("/api/chat")
async def chat(message: ChatMessage):
    try:
        result = agent_executor.run(message.message)
        
        return {
            "response": result
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

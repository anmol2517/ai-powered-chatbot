ai-chatbot/  
├── frontend                      // React frontend  
│   ├── public                    // Static assets  
│   ├── src                       // Source code  
│   │   ├── components            // Reusable components  
│   │   │   ├── ChatWindow.jsx  
│   │   │   └── Message.jsx  
│   │   ├── context               // Global state management  
│   │   │   └── ChatContext.js  
│   │   ├── api                   // API integration  
│   │   │   └── api.js  
│   │   ├── App.js                // Main app component  
│   │   └── index.js              // Entry point  
│   └── package.json              // Frontend dependencies  
├── backend                       // Python backend  
│   ├── app  
│   │   ├── __init__.py           // App initialization  
│   │   ├── models.py             // Database models  
│   │   ├── routes.py             // API routes  
│   │   └── langgraph_agent.py    // AI agent logic  
│   ├── config.py                 // Configuration settings  
│   ├── requirements.txt          // Backend dependencies  
│   └── run.py                    // Application entry point  
├── database                      // Database files  
│   ├── schema.sql                // Database schema  
│   └── sample_data.sql           // Sample data for testing  
└── README.md                     // Project documentation  

### Set Up the Database
```
CREATE DATABASE supplier_db;
USE supplier_db;

CREATE TABLE supplier (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE product (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    supplier_id INT,
    FOREIGN KEY (supplier_id) REFERENCES supplier(id)
);
```

```
INSERT INTO supplier (name) VALUES ('Supplier A'), ('Supplier B');
INSERT INTO product (name, supplier_id) VALUES ('Product 1', 1), ('Product 2', 2);
```

### Set Up the Backend
```
cd backend   >>>   Navigate to the backend folder
python -m venv venv   >>>   virtual environment
venv\Scripts\activate   >>>   On Windows
pip install -r requirements.txt   >>>   Install Dependencies / Packages
python run.py   >>>   Run the backend
```

### Set Up the Frontend
```
cd frontend   >>>   Install Dependencies
npm install
npm start   >>>   Run the Frontend
```

###  Test the Chatbot
- Open your browser and go to ```http://localhost:3000```.
- You should see the chatbot interface with a heading "AI-Powered Chatbot".

### Interact with the Chatbot:

- Type a query like
```
Find products from Supplier A
```

- The chatbot will send the query to the backend, which will:
>> Query the database for products from Supplier A.
>> Use the LangGraph agent to summarize the results.
>> Return the response to the frontend.

###  Verify Backend Logs
```
* Running on http://127.0.0.1:5000/ (Press CTRL+C to quit)
* Restarting with stat
* Debugger is active!
* Debugger PIN: 123-456-789
```

**Frontend**
- You type a query in the chat input box and click "Send".
- The query is sent to the backend via an API call ```(http://localhost:5000/api/chat)```.

**Backend**
- The Flask server receives the query and passes it to the LangGraph agent.
- The agent queries the database and summarizes the results using the LLM.

**Database**
- The database returns the relevant supplier and product information.

**Response**
- The backend sends the summarized response back to the frontend.
- The chatbot displays the response in the chat window.



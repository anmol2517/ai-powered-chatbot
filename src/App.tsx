import React from 'react';
import { Provider } from 'react-redux';
import { store } from './store/store';
import ChatInterface from './components/ChatInterface';

function App() {
  return (
    <Provider store={store}>
      <div className="min-h-screen bg-gray-100">
        <header className="bg-white shadow">
          <div className="max-w-7xl mx-auto py-6 px-4">
            <h1 className="text-3xl font-bold text-gray-900">
              AI Product Assistant
            </h1>
          </div>
        </header>
        <main className="max-w-7xl mx-auto py-6 sm:px-6 lg:px-8">
          <ChatInterface />
        </main>
      </div>
    </Provider>
  );
}

export default App;
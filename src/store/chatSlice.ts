import { createSlice, createAsyncThunk } from '@reduxjs/toolkit';
import { supabase } from '../lib/supabase';

interface ChatMessage {
  id: string;
  message: string;
  response: string;
  created_at: string;
}

interface ChatState {
  messages: ChatMessage[];
  loading: boolean;
  error: string | null;
}

const initialState: ChatState = {
  messages: [],
  loading: false,
  error: null,
};

export const sendMessage = createAsyncThunk(
  'chat/sendMessage',
  async (message: string) => {
    try {
      // Call your API endpoint here
      const response = await fetch('/api/chat', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ message }),
      });

      if (!response.ok) {
        throw new Error('Failed to send message');
      }

      const data = await response.json();
      
      // Store the chat history in Supabase
      const { data: chatData, error } = await supabase
        .from('chat_history')
        .insert({
          message,
          response: data.response,
        })
        .select()
        .single();

      if (error) throw error;
      return chatData;
    } catch (error) {
      throw error;
    }
  }
);

const chatSlice = createSlice({
  name: 'chat',
  initialState,
  reducers: {},
  extraReducers: (builder) => {
    builder
      .addCase(sendMessage.pending, (state) => {
        state.loading = true;
        state.error = null;
      })
      .addCase(sendMessage.fulfilled, (state, action) => {
        state.loading = false;
        state.messages.push(action.payload);
      })
      .addCase(sendMessage.rejected, (state, action) => {
        state.loading = false;
        state.error = action.error.message || 'An error occurred';
      });
  },
});

export default chatSlice.reducer;
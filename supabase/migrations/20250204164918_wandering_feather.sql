/*
  ------------Initial Schema Setup for AI Chatbot-------------

  1. New Tables
    - `suppliers`
      - Basic supplier information
    - `products`
      - Product details with supplier reference
    - `chat_history`
      - Store chat interactions
    
  2. Security
    - Enable RLS on all tables
    - Add policies for authenticated users
*/

-- Create suppliers table
CREATE TABLE IF NOT EXISTS suppliers (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  email text UNIQUE NOT NULL,
  phone text,
  address text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Create products table

CREATE TABLE IF NOT EXISTS products (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  supplier_id uuid REFERENCES suppliers(id),
  name text NOT NULL,
  description text,
  price decimal(10,2) NOT NULL,
  stock_quantity integer DEFAULT 0,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Create chat_history table

CREATE TABLE IF NOT EXISTS chat_history (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES auth.users(id),
  message text NOT NULL,
  response text NOT NULL,
  created_at timestamptz DEFAULT now()
);

-- Enable Row Level Security

ALTER TABLE suppliers ENABLE ROW LEVEL SECURITY;
ALTER TABLE products ENABLE ROW LEVEL SECURITY;
ALTER TABLE chat_history ENABLE ROW LEVEL SECURITY;

-- Create policies

CREATE POLICY "Allow authenticated read access to suppliers"
  ON suppliers FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Allow authenticated read access to products"
  ON products FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Users can read their own chat history"
  ON chat_history FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own chat messages"
  ON chat_history FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

-- Create indexes for better performance

CREATE INDEX IF NOT EXISTS idx_products_supplier ON products(supplier_id);
CREATE INDEX IF NOT EXISTS idx_chat_history_user ON chat_history(user_id);

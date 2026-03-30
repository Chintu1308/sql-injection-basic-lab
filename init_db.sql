-- 1. Create the 'users' table
DROP TABLE IF EXISTS users;
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username TEXT NOT NULL,
    password TEXT NOT NULL,
    role TEXT NOT NULL
);

-- 2. Create the 'products' table
DROP TABLE IF EXISTS products;
CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT,
    stock INTEGER DEFAULT 0,
    released BOOLEAN DEFAULT TRUE,
    image_url TEXT
);

-- 3. Seed Users (Targets for Authentication Bypass)
INSERT INTO users (username, password, role) VALUES 
('administrator', 'P4ssw0rd_Str0ng_2024!', 'administrator'),
('alice', 'alice123', 'user'),
('bob', 'password_bob', 'user');

-- 4. Seed Products (Targets for Union-Based and Logic-Based SQLi)
INSERT INTO products (name, description, stock, released, image_url) VALUES 
(
    'Laptop', 
    'High-end gaming laptop with RGB keyboard.', 
    10, 
    TRUE, 
    'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse2.mm.bing.net%2Fth%2Fid%2FOIP.lMwIFwgBiBq3g1KQkgcxxAHaEK%3Fpid%3DApi&f=1&ipt=45d7cc0821e9e3bfb0126cbba80bb533e158b6447416c297986d8be227ca520e&ipo=images'
),
(
    'Smartphone', 
    'Latest flagship model with 5G connectivity.', 
    25, 
    TRUE, 
    'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse3.mm.bing.net%2Fth%2Fid%2FOIP.sJLFhaJCytrOCaKlElT12QHaEK%3Fpid%3DApi&f=1&ipt=32a9dd8c30cc657453030acfdee3a5538795243bf0632b4f7d3bb19dc6f6656d&ipo=images'
),
(
    'Headphones', 
    'Noise-canceling over-ear headphones.', 
    15, 
    TRUE, 
    'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse1.mm.bing.net%2Fth%2Fid%2FOIP.WmrDAbmUFGD_R8LbuO5nRQHaEK%3Fpid%3DApi&f=1&ipt=9a6e5e8d836ad280e68fd6d009033845c4ac94db79b4a89cb289c73132713e08&ipo=images'
),
(
    'Hidden Prototype', 
    'UNRELEASED - TOP SECRET. Experimental AI processor.', 
    1, 
    FALSE, -- This is 'False', so it won't show in normal searches
    'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse1.mm.bing.net%2Fth%2Fid%2FOIP.TRRXgpocoNM9Xr0zC13r8AHaEb%3Fpid%3DApi&f=1&ipt=39f347f9340fcafb7e923d8424212514bed6704d46a708ba0c9894cfa10c6643&ipo=images'
);
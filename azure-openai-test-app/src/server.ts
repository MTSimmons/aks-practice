import express, { Request, Response } from 'express';
import AzureOpenAI from './azureOpenAI';

const app = express();
const port = process.env.PORT || 3000;

// Middleware to parse JSON requests
app.use(express.json());

// Convert GET / so it displays a form or processes the prompt (via the query string)
app.get('/', async (req: Request, res: Response) => {
    // Get the prompt from query parameters if present
    const userPrompt = req.query.prompt as string;
  
    // If no prompt, show a simple HTML form
    if (!userPrompt) {
      return res.send(`
        <html>
          <head>
            <title>Azure OpenAI Chat</title>
          </head>
          <body>
            <h1>Azure OpenAI Chat</h1>
            <form method="GET" action="/">
              <label for="prompt">Enter prompt:</label>
              <input type="text" id="prompt" name="prompt" />
              <button type="submit">Send</button>
            </form>
          </body>
        </html>
      `);
    }
  
    // If a prompt is provided, send it to Azure OpenAI
    try {
      const azureOpenAI = new AzureOpenAI();
      const result = await azureOpenAI.chat(userPrompt);
      const content = result.choices?.[0]?.message?.content ?? "No response content available";
      return res.send(`
        <html>
          <head>
            <title>Azure OpenAI Chat</title>
          </head>
          <body>
            <h2>Prompt: ${userPrompt}</h2>
            <p><strong>Response:</strong> ${content}</p>
            <a href="/">Back</a>
          </body>
        </html>
      `);
    } catch (error: any) {
      return res.status(500).send(`Error: ${error.message}`);
    }
  });
  

app.post('/chat', async (req: Request, res: Response) => {
  const { prompt } = req.body;
  if (!prompt) {
    return res.status(400).json({ error: 'Prompt is required' });
  }
  
  try {
    const azureOpenAI = new AzureOpenAI();
    const result = await azureOpenAI.chat(prompt);
    const content = result.choices?.[0]?.message?.content ?? "No response content available";
    res.json({ response: content });
  } catch (error: any) {
    res.status(500).json({ error: error.message });
  }
});

app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});
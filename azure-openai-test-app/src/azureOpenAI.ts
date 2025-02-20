import * as dotenv from 'dotenv';
dotenv.config();

class AzureOpenAI {
  private endpoint: string;
  private apiKey: string;
  private deploymentName: string;

  constructor() {
    this.endpoint = process.env.AZURE_OPENAI_ENDPOINT || '';
    this.apiKey = process.env.AZURE_OPENAI_API_KEY || '';
    this.deploymentName = process.env.AZURE_OPENAI_DEPLOYMENT_NAME || '';
    if (!this.endpoint || !this.apiKey || !this.deploymentName) {
      throw new Error('Missing Azure OpenAI configuration in environment variables.');
    }
  }

  async testRequest() {
    const url = this.endpoint; // Uses full URL from .env
    console.log('Request URL:', url); // Debug: log the actual URL

    const body = {
      messages: [
        { role: "user", content: "Hello, Azure OpenAI!" }
      ],
      max_tokens: 5
    };

    const response = await fetch(url, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'api-key': this.apiKey
      },
      body: JSON.stringify(body)
    });

    if (!response.ok) {
      throw new Error(`Request failed: ${response.statusText}`);
    }

    return response.json();
  }

  // New method for interactive chat
  async chat(userPrompt: string) {
    const url = this.endpoint;
    console.log('Request URL:', url);

    const body = {
      messages: [
        { role: "user", content: userPrompt }
      ],
      max_tokens: 150
    };

    const response = await fetch(url, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'api-key': this.apiKey
      },
      body: JSON.stringify(body)
    });
    
    if (!response.ok) {
      throw new Error(`Request failed: ${response.statusText}`);
    }

    return response.json();
  }
}

export default AzureOpenAI;
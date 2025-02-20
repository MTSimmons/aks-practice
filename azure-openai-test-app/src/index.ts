import AzureOpenAI from './azureOpenAI';
import readline from 'readline';

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

async function startChat() {
  const azureOpenAI = new AzureOpenAI();
  
  rl.question("Enter prompt: ", async (userPrompt) => {
    try {
      const result = await azureOpenAI.chat(userPrompt);
      // Instead of logging the entire result, get the assistant's message content:
      const content = result.choices?.[0]?.message?.content ?? "No response content available";
      console.log("Response:", content);
    } catch (error) {
      console.error("Error during chat:", error);
    } finally {
      rl.close();
    }
  });
}

startChat();
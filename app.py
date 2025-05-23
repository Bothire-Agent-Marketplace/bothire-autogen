import os
import json
from flask import Flask, render_template, request, jsonify
from flask_cors import CORS
import autogen
from autogen import AssistantAgent, UserProxyAgent, config_list_from_json
import logging

# Set up logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

app = Flask(__name__)
CORS(app)

# Configure Autogen
config_list = [{
    "model": "gpt-4",
    "api_key": os.environ.get("OPENAI_API_KEY")
}]

# Create a custom conversable agent that stores conversation history
class WebUserProxyAgent(UserProxyAgent):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.conversation_history = []
    
    def send(self, message, recipient, request_reply=None, silent=False):
        self.conversation_history.append({
            "sender": self.name,
            "recipient": recipient.name,
            "message": message
        })
        return super().send(message, recipient, request_reply, silent)
    
    def receive(self, message, sender, request_reply=None, silent=False):
        self.conversation_history.append({
            "sender": sender.name,
            "recipient": self.name,
            "message": message
        })
        return super().receive(message, sender, request_reply, silent)

# Initialize agents
assistant = AssistantAgent(
    name="assistant",
    llm_config={
        "config_list": config_list,
        "temperature": 0.7,
    },
    system_message="You are a helpful AI assistant. Help the user with their tasks."
)

user_proxy = WebUserProxyAgent(
    name="user",
    human_input_mode="NEVER",
    max_consecutive_auto_reply=0,
    code_execution_config={"use_docker": False}
)

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/api/chat', methods=['POST'])
def chat():
    try:
        data = request.json
        message = data.get('message', '')
        
        if not message:
            return jsonify({"error": "No message provided"}), 400
        
        # Clear previous conversation history
        user_proxy.conversation_history = []
        
        # Initiate the conversation
        user_proxy.initiate_chat(
            assistant,
            message=message,
            clear_history=True
        )
        
        # Get the conversation history
        conversation = user_proxy.conversation_history
        
        return jsonify({
            "conversation": conversation,
            "status": "success"
        })
    
    except Exception as e:
        logger.error(f"Error in chat endpoint: {str(e)}")
        return jsonify({"error": str(e)}), 500

@app.route('/api/health', methods=['GET'])
def health():
    return jsonify({"status": "healthy"})

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 8080))
    app.run(host='0.0.0.0', port=port, debug=False) 
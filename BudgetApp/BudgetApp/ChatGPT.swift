//
//  ChatGPT.swift
//  BudgetApp
//
//  Created by Alex Rhodes and Nicholas Mollica on 11/9/23.
//


import Foundation

struct ChatGPT {              //backend for AI
    let apiKey: String
    
    func sendMessage(_ message: String, completion: @escaping (Result<String, Error>) -> Void) {
        let apiKey = "sk" // Replace "YOUR_API_KEY" with your actual API key
        let modelName = "gpt-3.5-turbo" // Replace "YOUR_MODEL_NAME" with the desired model name
        
        let url = URL(string: "https://api.openai.com/v1/chat/completions")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization") 
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let requestBody: [String: Any] = [      //request body for AI
            "model": modelName,
            "messages": [
                ["role": "system", "content": "You are a helpful assistant."],   //system input
                ["role": "user", "content": message]    //user input
            ],
            "max_tokens": 200              //max tokens for AI (max length of response)
        ]
        
        let jsonData = try! JSONSerialization.data(withJSONObject: requestBody)   //json data for request body
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in   //takes URL request and returns response
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let data = data {                             //edits response from AI
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let choices = json["choices"] as? [[String: Any]],       //choices for AI response
                   let content = choices.first?["message"] as? [String: Any],
                   let text = content["content"] as? String {
                    completion(.success(text))              
                    return                    //returns AI response
                }
                
                completion(.failure(NSError(domain: "Response Parsing Error", code: 0, userInfo: nil)))  //if error in response
            }
        }
        
        task.resume()
    }
}

//
//  NetworkRequests.swift
//  OnTheMap
//
//  Created by Ramon Yepez on 5/12/21.
//

import Foundation



class NetworkRequests {
    
    
    struct Auth {
        static var registered = ""
        static var key = ""
        static var sessionId = ""
        static var sessionExpiration = ""
        static var firstName = ""
        static var lastName = ""
        static var mediaURL = ""
        static var location = ""
        static var latitude: Double = 0.0
        static var longitude: Double = 0.0
        static var objectId: String = ""
        static var checkIfStudentPostedAlready: Bool? = nil
        
    }
    
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1"
        
        case login
        case getStudentLocation
        case postStudentLocation
        case updateStudentLcation(String)
        case logOut
        case getStudentProfile(String)
        
        var stringValue: String {
            switch self {
            
            case .login:
                return Endpoints.base + "/session"
            case .getStudentLocation:
                return Endpoints.base + "/StudentLocation?order=-updatedAt&limit=100"
            case .postStudentLocation:
                return Endpoints.base + "/StudentLocation"
            case .updateStudentLcation(let objectID):
                return Endpoints.base + "/StudentLocation/\(objectID)"
            case .logOut:
                return Endpoints.base + "/session"
            case .getStudentProfile(let uniqueID):
                return Endpoints.base + "/StudentLocation?uniqueKey=\(uniqueID)"
                
            }
            
        }
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let test = try! JSONEncoder().encode(body)
        request.httpBody = try! JSONEncoder().encode(body)
        print(String(data: test, encoding: .utf8)!)
        
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let range = (5..<data.count)
            let newData = data.subdata(in: range)
            
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: newData)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
                
            } catch {
                do {
                    let errorResponse = try decoder.decode(LoginError.self, from: data) as Error
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
    }
    
    class func taskForPUTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void) {
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        
        let test = try! JSONEncoder().encode(body)
        request.httpBody = try! JSONEncoder().encode(body)
        print(String(data: test, encoding: .utf8)!)
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            print(String(data: data, encoding: .utf8)!)
            
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
                
            } catch {
                do {
                    let errorResponse = try decoder.decode(LoginError.self, from: data) as Error
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
    }
    
    
    class func login(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        let body = UserLogin(udacity: LoginRequest(username: username, password: password))
        taskForPOSTRequest(url: Endpoints.login.url, responseType: LoginReponse.self, body: body) { response, error in
            if let response = response {
                print(response)
                Auth.sessionId = response.session.id
                // I got use the number generated by the API but it changes everytime so this hard code data will be my account ID
                Auth.key = "202035561600"
                
                //hard coding dummy data for first name and lastname. I would pretend like I got the data from the API.
                Auth.firstName = "Ramon"
                Auth.lastName = "LastName"
                
                completion(true, nil)
            } else {
                //print(error?.localizedDescription)
                completion(false, error)
            }
        }
    }
    
    class func taskDELETE<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) {
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data else {
                return
            }
            Auth.sessionId = ""
            Auth.key = ""
            print(Auth.sessionId)
            let newData = data.subdata(in: 5..<data.count)
            
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: newData)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                print("Error :( ")
            }
            
        }
        task.resume()
        
    }
    
    class func logDelete(completion: @escaping (Bool, Error?) -> Void) {
        
        taskDELETE(url: Endpoints.logOut.url, responseType: LogOutResponse.self) {(response, error) in
            if let response = response {
                print("You print the right thing... \(response.session.expiration)")
                completion(true, nil)
            } else {
                completion(false, error)
            }
            
        }
        
    }
    
    class func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) {
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(LoginError.self, from: data)
                    
                    DispatchQueue.main.async {
                        completion(nil,errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
                
            }
            
        }
        task.resume()
    }
    
    class func taskForPOSTStudentLocationt<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let test = try! JSONEncoder().encode(body)
        request.httpBody = try! JSONEncoder().encode(body)
        print(String(data: test, encoding: .utf8)!)
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
                
            } catch {
                do {
                    let errorResponse = try decoder.decode(PostError.self, from: data) as Error
                    DispatchQueue.main.async {
                        print(errorResponse)
                        completion(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
    }
    
    class func postStudentLocation(completion: @escaping (Bool, Error?) -> Void) {
        
        let body = StudentLocationPost(uniqueKey: Auth.key, firstName: Auth.firstName, lastName: Auth.lastName, mapString: Auth.location, mediaURL: Auth.mediaURL , latitude: Auth.latitude, longitude: Auth.longitude)
        
        taskForPOSTStudentLocationt(url: Endpoints.postStudentLocation.url, responseType: PostLocationResponse.self, body: body) { (response, error) in
            if let response = response {
                //setting the objectId so we can use it to update student location
                Auth.objectId = response.objectId
                print(response)
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
        
    }
    
    
    class func studentLocationPUT(completion: @escaping (Bool, Error?) -> Void) {
        
        let body = StudentLocationPost(uniqueKey: Auth.key, firstName: Auth.firstName, lastName: Auth.lastName, mapString: Auth.location, mediaURL: Auth.mediaURL , latitude: Auth.latitude, longitude: Auth.longitude)
        
        taskForPUTRequest(url: Endpoints.updateStudentLcation(Auth.objectId).url, responseType: UpdateLocation.self, body: body) { (response, error) in
            if let response = response {
                //setting the objectId so we can use it to update student location
                print(response)
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
        
    }
    
    class func getStudentLocation(completion: @escaping ([StudentProperties], Error?) -> Void){
        
        taskForGETRequest(url: Endpoints.getStudentLocation.url, responseType: StudentsLocation.self) { (response, error) in
            
            if let response = response {
                completion(response.results, nil)
            } else {
                completion([], nil)
            }
        }
    }
    
    class func getStudentOne(completion: @escaping ([StudentProperties], Error?) -> Void){
        
        taskForGETRequest(url: Endpoints.getStudentProfile(Auth.key).url, responseType: StudentsLocation.self) { (response, error) in
            
            if let response = response {
                completion(response.results, nil)
            } else {
                completion([], nil)
            }
        }
    }
    
    class func checkIfStudentPostedAlready() -> Bool {
        
        
        var myArray = [Bool]()
        for index in Range(0...(DataModel.studentLocations.count - 1)) {
            
            if DataModel.studentLocations[index].uniqueKey == NetworkRequests.Auth.key {
                myArray.append(true)
            }
            
        }
        return myArray.contains(true)
        
    }
    
}

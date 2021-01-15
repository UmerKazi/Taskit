
import Foundation
import FirebaseAuth

class AuthManager {
    
    let auth = Auth.auth()
    
    func login(withEmail email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void ) {
        auth.signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func signUp(withEmail email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void ) {        
        auth.createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func logout(completion: (Result<Void, Error>) -> Void) {
        do {
            try auth.signOut()
            completion(.success(()))
        } catch(let error) {
            completion(.failure(error))
        }
    }
    
    func isUserLoggedIn() -> Bool {
        return auth.currentUser != nil
    }
    
    func getUserId() -> String? {
        return auth.currentUser?.uid
    }
    
}

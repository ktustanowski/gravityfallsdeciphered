// Gravity Falls - deciphered

import Foundation

class Decryptor {
    fileprivate var alphabet = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
    
    func decrypt(_ input: String) -> String? {
        var output = ""
        for character in input.characters {
            output += substitute(String(character).lowercased())
        }
        
        return output
    }
    
    func substitute(_ string: String) -> String {
        assertionFailure("Override!")
        return ""
    }
}

/// Works for episodes 1 - 6. Three letters back - you can hear this when you play Gravity Falls intro backwards.
class ShiftLettersDecryptor: Decryptor {
    
    fileprivate let shift: Int
    
    init(shift: Int) {
        self.shift = shift
        
        super.init()
    }
    
    override func substitute(_ string: String) -> String {
        guard let index = alphabet.index(of: string) else { return string }
        var movedIndex = index + shift
        if movedIndex < 0 {
            movedIndex = alphabet.count + movedIndex
        } else if movedIndex > alphabet.count - 1 {
            movedIndex = movedIndex - (alphabet.count - 1)
        }
        
        return alphabet[movedIndex]
    }
}

/// Works for episodes 7 - 13. The clue to this was 6th episode cipher - "mr. ceasarian will be out next week mr. atbash will substitute". Ceasar cipher changed to atbash (both are substitution ciphers)
class AtbashDecryptor: Decryptor {
    override func substitute(_ string: String) -> String {
        guard let index = alphabet.index(of: string) else { return string }
        
        return alphabet[alphabet.count - index - 1]
    }
}

// Works for episodes 14 - 19 + note on a map from episode 20.
class NumbersDecryptor: Decryptor {
    
    fileprivate var cipherDictionary = [String : String]()
    
    override func decrypt(_ input: String) -> String? {
        cipherDictionary.removeAll()
        let numbers = input.replacingOccurrences(of: " ", with: "-")
            .replacingOccurrences(of: ":", with: "")
            .replacingOccurrences(of: "\"", with: "")
            .replacingOccurrences(of: ",", with: "")
            .replacingOccurrences(of: "`", with: "")
            .replacingOccurrences(of: ".", with: "")
            .replacingOccurrences(of: "'", with: "-")
            .replacingOccurrences(of: "?", with: "")
            .replacingOccurrences(of: "!", with: "")
            .replacingOccurrences(of: "'", with: "-")
            .replacingOccurrences(of: "–", with: "-")
            .replacingOccurrences(of: "“", with: "")
            .components(separatedBy: "-")
        
        for number in numbers {
            guard cipherDictionary[number] == nil else { continue }
            cipherDictionary[number] = substitute(number)
        }
        var output = input
        let allNumbers = cipherDictionary.keys.sorted { Int($0)! > Int($1)! }
        
        for number in allNumbers {
            guard let text = cipherDictionary[number] else { continue }
            
            output = output.replacingOccurrences(of: number, with: text)
        }
        
        return output.replacingOccurrences(of: "-", with: "").replacingOccurrences(of: "–", with: "")
    }
    
    override func substitute(_ string: String) -> String {
        guard let index = Int(string),
            index > 0, index < alphabet.count else { return "?" }
        return alphabet[index - 1].isEmpty ? string : alphabet[index - 1]
    }
}

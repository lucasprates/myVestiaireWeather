//
//  DictionaryExtensions.swift
//  MyVestiaireWeather
//
//  Created by Lucas on 04/08/2019.
//  Copyright © 2019 LucasPrates. All rights reserved.
//

import UIKit

class DictionaryExtensions: NSObject {

}

extension Dictionary {
    
    func isEqualTo(anyValueDictionary: [String: Any?]?) -> Bool {
        let thisDictionary: [String: Any] = self.getAsStringAnyDictionary() ?? [:]
        let dictionaryToCompare: [String: Any] = anyValueDictionary?.getAsStringAnyDictionary() ?? [:]
        return (thisDictionary as NSDictionary).isEqual(to: dictionaryToCompare)
    }
    
    func convertToData() -> Data? {
        return NSKeyedArchiver.archivedData(withRootObject: self)
    }
    
    func getAsStringAnyDictionary() -> [String: Any]? {
        var newDictionary: [String: Any] = [:]
        for keyUnit in self.keys {
            let valueAsAny: Any? = self[keyUnit] as Any?
            if let valueFilled: Any = valueAsAny, let keyAsStringFilled: String = keyUnit as? String {
                newDictionary[keyAsStringFilled] = valueFilled
            }
        }
        return newDictionary
    }
}

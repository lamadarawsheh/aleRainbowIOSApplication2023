//
//  DateFormatter.swift
//  RainbowApp
//
//  Created by Lama Darawsheh on 03/04/2023.
//

import Foundation
class DateFormatterr{
    
    func formate(_ date:Date)->Date{
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        
        let stringDate = formatter.string(from: date)
        let formattedDate = formatter.date(from:stringDate)
        return formattedDate ?? Date()
    }
}

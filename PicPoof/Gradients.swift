//
//  Gradients.swift
//  PicPoof
//
//  Created by Anya Popova on 2024-12-10.
//
import SwiftUI
import Foundation

struct Gradients {
    static let gradients: [String: LinearGradient] = [
        "January": LinearGradient(
            stops: [
                Gradient.Stop(color: Color(red: 0.79, green: 0.81, blue: 1).opacity(0.9), location: 0.00),
                Gradient.Stop(color: Color(red: 0.64, green: 0.66, blue: 1).opacity(0.9), location: 1.00),
            ],
            startPoint: UnitPoint(x: 0, y: 0),
            endPoint: UnitPoint(x: 1, y: 1)
        ),
        "February": LinearGradient(
            stops: [
                Gradient.Stop(color: Color(red: 0.79, green: 1, blue: 1).opacity(0.9), location: 0.00),
                Gradient.Stop(color: Color(red: 0.64, green: 0.98, blue: 1).opacity(0.9), location: 1.00),
            ],
            startPoint: UnitPoint(x: 0, y: 0),
            endPoint: UnitPoint(x: 1, y: 1)
        ),
        "March": LinearGradient(
            stops: [
                Gradient.Stop(color: Color(red: 0.83, green: 1, blue: 0.79).opacity(0.9), location: 0.00),
                Gradient.Stop(color: Color(red: 0.67, green: 1, blue: 0.64).opacity(0.9), location: 1.00),
            ],
            startPoint: UnitPoint(x: 0, y: 0),
            endPoint: UnitPoint(x: 1, y: 1)
        ),
        "April": LinearGradient(
            stops: [
                Gradient.Stop(color: Color(red: 1, green: 0.99, blue: 0.79).opacity(0.9), location: 0.00),
                Gradient.Stop(color: Color(red: 1, green: 0.99, blue: 0.64).opacity(0.9), location: 1.00),
            ],
            startPoint: UnitPoint(x: 0, y: 0),
            endPoint: UnitPoint(x: 1, y: 1)
        ),
        "May": LinearGradient(
            stops: [
                Gradient.Stop(color: Color(red: 1, green: 0.88, blue: 0.79).opacity(0.9), location: 0.00),
                Gradient.Stop(color: Color(red: 1, green: 0.77, blue: 0.64).opacity(0.9), location: 1.00),
            ],
            startPoint: UnitPoint(x: 0, y: 0),
            endPoint: UnitPoint(x: 1, y: 1)
        ),
        "June": LinearGradient(
            stops: [
                Gradient.Stop(color: Color(red: 1, green: 0.79, blue: 0.88).opacity(0.9), location: 0.00),
                Gradient.Stop(color: Color(red: 1, green: 0.64, blue: 0.64).opacity(0.9), location: 1.00),
            ],
            startPoint: UnitPoint(x: 0, y: 0),
            endPoint: UnitPoint(x: 1, y: 1)
        ),
        "July": LinearGradient(
            stops: [
                Gradient.Stop(color: Color(red: 0.96, green: 0.79, blue: 1).opacity(0.9), location: 0.00),
                Gradient.Stop(color: Color(red: 1, green: 0.64, blue: 0.86).opacity(0.9), location: 1.00),
            ],
            startPoint: UnitPoint(x: 0, y: 0),
            endPoint: UnitPoint(x: 1, y: 1)
        ),
        "August": LinearGradient(
            stops: [
                Gradient.Stop(color: Color(red: 0.9, green: 0.79, blue: 1).opacity(0.9), location: 0.00),
                Gradient.Stop(color: Color(red: 0.76, green: 0.52, blue: 1).opacity(0.9), location: 1.00),
            ],
            startPoint: UnitPoint(x: 0, y: 0),
            endPoint: UnitPoint(x: 1, y: 1)
        ),
        "September": LinearGradient(
            stops: [
                Gradient.Stop(color: Color(red: 1, green: 0.88, blue: 0.79).opacity(0.9), location: 0.00),
                Gradient.Stop(color: Color(red: 1, green: 0.77, blue: 0.64).opacity(0.9), location: 1.00),
            ],
            startPoint: UnitPoint(x: 0, y: 0),
            endPoint: UnitPoint(x: 1, y: 1)
        ),
        "October": LinearGradient(
            stops: [
                Gradient.Stop(color: Color(red: 1, green: 0.79, blue: 0.88).opacity(0.9), location: 0.00),
                Gradient.Stop(color: Color(red: 1, green: 0.64, blue: 0.64).opacity(0.9), location: 1.00),
            ],
            startPoint: UnitPoint(x: 0, y: 0),
            endPoint: UnitPoint(x: 1, y: 1)
        ),
        "November": LinearGradient(
            stops: [
                Gradient.Stop(color: Color(red: 0.96, green: 0.79, blue: 1).opacity(0.9), location: 0.00),
                Gradient.Stop(color: Color(red: 1, green: 0.64, blue: 0.86).opacity(0.9), location: 1.00),
            ],
            startPoint: UnitPoint(x: 0, y: 0),
            endPoint: UnitPoint(x: 1, y: 1)
        ),
        "December": LinearGradient(
            stops: [
                Gradient.Stop(color: Color(red: 0.9, green: 0.79, blue: 1).opacity(0.9), location: 0.00),
                Gradient.Stop(color: Color(red: 0.76, green: 0.52, blue: 1).opacity(0.9), location: 1.00),
            ],
            startPoint: UnitPoint(x: 0, y: 0),
            endPoint: UnitPoint(x: 1, y: 1)
        ),
        
        "Flashbacks": LinearGradient(
            stops: [
            Gradient.Stop(color: Color(red: 0.78, green: 0.84, blue: 1), location: 0.00),
            Gradient.Stop(color: Color(red: 0.57, green: 0.69, blue: 1), location: 1.00),
            ],
            startPoint: UnitPoint(x: 0, y: 0.5),
            endPoint: UnitPoint(x: 1, y: 0.5)
        ),
        
        "Recents": LinearGradient(
            stops: [
            Gradient.Stop(color: Color(red: 1, green: 0.79, blue: 0.79), location: 0.00),
            Gradient.Stop(color: Color(red: 1, green: 0.64, blue: 0.64), location: 1.00),
            ],
            startPoint: UnitPoint(x: 0, y: 0.5),
            endPoint: UnitPoint(x: 1, y: 0.5)
        ),
        
        "Random": LinearGradient(
            stops: [
            Gradient.Stop(color: Color(red: 1, green: 0.91, blue: 0.79), location: 0.00),
            Gradient.Stop(color: Color(red: 1, green: 0.86, blue: 0.68), location: 1.00),
            ],
            startPoint: UnitPoint(x: 0, y: 0.5),
            endPoint: UnitPoint(x: 1, y: 0.5)
        ),
    ]
}

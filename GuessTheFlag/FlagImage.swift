//
//  FlagImage.swift
//  GuessTheFlag
//
//  Created by Dechon Ryan on 5/3/24.
//

import SwiftUI

struct FlagImage: View {
    var countries: [String]
    var number: Int
    
    var body: some View {
        Image(countries[number])
            .clipShape(.capsule)
            .shadow(radius: 5)
    }
}

#Preview {
    FlagImage(countries: ["US", "UK", "Uganda"], number: 0)
}

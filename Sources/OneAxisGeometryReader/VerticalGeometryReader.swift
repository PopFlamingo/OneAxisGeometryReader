/*
 Copyright 2019 Trevör Anne Denise
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

import SwiftUI

struct HeightReader : PreferenceKey, Equatable {
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        // FIXME: What should be done here
        // Setting value to nextValue ends up erasing the only meaningful value with 0
        // Maybe a SwiftUI bug ?
    }
}


struct HeightReaderView : View {
    var body: some View {
        GeometryReader { geometry in
            Color.clear.preference(key: HeightReader.self, value: geometry.size.height)
        }
    }
}

public struct VerticalGeometryReader<Content: View> : View {
    
    var content: (CGFloat)->Content
    @State private var height: CGFloat = 0
    
    public init(@ViewBuilder content: @escaping (CGFloat)->Content) {
        self.content = content
    }
    
    public var body: some View {
        content(height)
            .frame(minHeight: 0, maxHeight: .infinity)
            .background(HeightReaderView())
            .onPreferenceChange(HeightReader.self) { height in
                self.height = height
            }
        
    }
}

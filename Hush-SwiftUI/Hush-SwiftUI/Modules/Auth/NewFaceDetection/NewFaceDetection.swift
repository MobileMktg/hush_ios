//
//  NewFaceDetection.swift
//  Hush-SwiftUI
//
//  Created by Serge Vysotsky on 04.05.2020.
//  Copyright © 2020 AppServices. All rights reserved.
//

import SwiftUI

struct NewFaceDetection<ViewModel: NewFaceDetectionViewModeled>: View, AuthAppScreens {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @ObservedObject var viewModel: ViewModel
    
    // SwiftUI bug doesn't allow to move this to ViewModel
    @State private var maskEnabled = false
    
    var body: some View {
        VStack(spacing: 0) {
            arView
            maskMenu
        }.background(Color.black.edgesIgnoringSafeArea(.all))
    }
    
    private var arView: some View {
        ARFaceDetectorView(maskImage: viewModel.maskImage,
                           maskEnabled: maskEnabled,
                           shouldTakeImage: viewModel.shouldTakeImage,
                           capturedImage: $viewModel.capturedImage)
            .edgesIgnoringSafeArea(.top)
            .overlay(slider, alignment: .bottom)
            .overlay(categoryImages, alignment: .bottom)
    }
    
    private var maskMenu: some View {
        VStack {
            Spacer()
            HStack {
                Button(action: viewModel.previousCategories) {
                    Image("backArrow")
                        .foregroundColor(.white)
                        .opacity(viewModel.canGoPreviousCategories ? 1 : 0.2)
                        .padding()
                }.disabled(!viewModel.canGoPreviousCategories)
                Spacer()
                HStack(spacing: 20) {
                    ForEach(viewModel.visibleCategories, id: \.self) { category in
                        MaskImage(name: category.categoryImage)
                            .frame(maxWidth: 90, maxHeight: 90)
                            .shadow(color: .white, radius: 30, x: 0, y: 4)
                            .onTapGesture {
                                self.viewModel.selectedCategory = category
                            }
                    }
                    
                    ForEach(0 ..< 3 - viewModel.visibleCategories.count, id: \.self) { _ in
                        MaskImage(name: self.viewModel.visibleCategories.first!.categoryImage)
                            .frame(maxWidth: 90, maxHeight: 90)
                            .hidden()
                    }
                }
                Spacer()
                Button(action: viewModel.nextCategories) {
                    Image("backArrow")
                        .rotationEffect(.radians(.pi), anchor: .center)
                        .foregroundColor(.white)
                        .opacity(viewModel.canGoNextCategories ? 1 : 0.2)
                        .padding()
                }.disabled(!viewModel.canGoNextCategories)
            }.padding(.horizontal)

            Spacer()

            HStack(spacing: 11) {
                if maskEnabled || viewModel.maskImage != nil {
                    borderedButton(action: reset, title: "Reset")
                }
                
                borderedButton(action: viewModel.done, title: "Done")
            }.padding(.horizontal, 32)
            .padding(.bottom)
        }.aspectRatio(414 / 239, contentMode: .fit)
        .background(Color.black)
    }
    
    private var categoryImages: some View {
        HStack(alignment: .bottom) {
            if viewModel.selectedCategory != nil {
                ForEach(0..<3, id: \.self) { i in
                    ScrollView(showsIndicators: false) {
                        VStack {
                            ForEach(self.viewModel.selectedCategory!.categoryImages, id: \.self) { name in
                                MaskImage(name: name)
                                    .frame(maxWidth: 120, maxHeight: 120)
                                    .onTapGesture {
                                        self.viewModel.selectMask(name)
                                    }
                            }.rotationEffect(.radians(.pi), anchor: .center)
                        }
                    }.rotationEffect(.radians(.pi), anchor: .center)
                    .opacity(self.viewModel.selectedCategory!.rawValue % 3 == i ? 1 : 0)
                }
            }
        }
    }
    
    private var slider: some View {
        MaskSlider(isEnabled: $maskEnabled)
            .padding()
            .background(RoundedRectangle(cornerRadius: 6)
                .fill(Color.white)
                .frame(height: 44))
            .padding(.horizontal)
                .opacity(0.5)
    }
    
    func reset() {
        viewModel.reset()
        maskEnabled = false
    }
}

struct MaskImage: View {
    let name: String
    
    var body: some View {
        Image(name)
            .resizable()
            .scaledToFit()
    }
}

struct NewFaceDetection_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                NewFaceDetection(viewModel: NewFaceDetectionViewModel())
                    .withoutBar()
            }
            
            NavigationView {
                NewFaceDetection(viewModel: NewFaceDetectionViewModel())
                    .withoutBar()
            }.previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro Max"))
            
            NavigationView {
                NewFaceDetection(viewModel: NewFaceDetectionViewModel())
                    .withoutBar()
            }.previewDevice(PreviewDevice(rawValue: "iPhone 8"))
        }
    }
}
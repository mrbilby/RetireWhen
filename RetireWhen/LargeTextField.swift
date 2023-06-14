//
//  LargeTextField.swift
//  RetireWhen
//
//  Created by James Bailey on 05/06/2023.
//

import SwiftUI

struct TextView: UIViewRepresentable {
    @Binding var text: String
    var placeholder: String
    @Environment(\.colorScheme) var colorScheme


    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.delegate = context.coordinator
        textView.font = UIFont.systemFont(ofSize: 17)
        

        if colorScheme == .dark {
            textView.text = text
            textView.textColor = UIColor.white
        } else {
            textView.text = text
            textView.textColor = UIColor.black
        }
        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        if uiView.text == placeholder {
            if colorScheme == .dark {
                uiView.text = text
                uiView.textColor = UIColor.white
            } else {
                uiView.text = text
                uiView.textColor = UIColor.black
            }
        } else {
            if colorScheme == .dark {
                uiView.text = text
                uiView.textColor = UIColor.white
            } else {
                uiView.text = text
                uiView.textColor = UIColor.black
            }
        }
    }


    class Coordinator: NSObject, UITextViewDelegate {
        var parent: TextView

        init(_ parent: TextView) {
            self.parent = parent
        }

        func textViewDidChange(_ textView: UITextView) {
            self.parent.text = textView.text
        }

        func textViewDidBeginEditing(_ textView: UITextView) {
            if textView.textColor == UIColor.lightGray {
                textView.text = nil
                textView.textColor = UIColor.black
            }
        }

        func textViewDidEndEditing(_ textView: UITextView) {
            if textView.text.isEmpty {
                textView.text = parent.placeholder
                textView.textColor = UIColor.lightGray
            }
        }
    }
}

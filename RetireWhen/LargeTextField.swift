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

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.delegate = context.coordinator
        textView.font = UIFont.systemFont(ofSize: 17)
        
        if text.isEmpty {
            textView.text = placeholder
            textView.textColor = UIColor.lightGray
        } else {
            textView.text = text
            textView.textColor = UIColor.black
        }
        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        if uiView.text == placeholder {
            if !text.isEmpty {
                uiView.text = text
                uiView.textColor = UIColor.black
            }
        } else {
            if uiView.text.isEmpty {
                uiView.text = placeholder
                uiView.textColor = UIColor.lightGray
            } else {
                text = uiView.text
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

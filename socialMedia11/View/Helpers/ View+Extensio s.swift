//
//   View+Extensions.swift
//  socialMedia11
//
//  Created by marwa awwad mohamed awwad on 11.07.2023.
//

import SwiftUI
// MARK: View Extensions For UI Building
extension View{
    func closeKeyBoard(){
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func disableWithOpacity(_ condition : Bool)->some View{
        self
            .disabled(condition)
            .opacity(condition ? 0.6 : 1)
    }
                func hAlign(_ alignment: Alignment)->some View{
                    self
                        .frame(maxWidth: .infinity,alignment: alignment)
                }
                func vAlign(_ alignment: Alignment)->some View{
                    self
                        .frame (maxHeight: .infinity,alignment: alignment)
                }
                //custum border view with padding
                func border(_ width: CGFloat,_ color: Color)->some View{
                    self
                        .padding(.horizontal,15)
                        .padding(.vertical,10)
                        .background{
                            RoundedRectangle(cornerRadius: 5, style: .continuous)
                                .stroke(color, lineWidth: width)
                        }
                }
                //custom fill view padding
                func fillView( _ color: Color)->some View{
                    self
                        .padding(.horizontal,15)
                        .padding(.vertical,10)
                        .background{
                            RoundedRectangle(cornerRadius: 5, style: .continuous)
                                .fill(color)
                            
                        }
                }
            }
            
        
    


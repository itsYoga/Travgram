//
//  ProfileHeaderView.swift
//  Travgram
//
//  Created by Jesse Liang on 2024/12/22.
//

import SwiftUI

struct ProfileHeaderView: View {
    @Bindable var user: User
    @Binding var isEditing: Bool

    var body: some View {
        VStack(spacing: 10) {
            // Profile Picture
            HStack {
                if let profileImageURL = user.profileImageURL,
                   let url = URL(string: profileImageURL),
                   let imageData = try? Data(contentsOf: url),
                   let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())
                } else {
                    Circle()
                        .fill(Color.gray)
                        .frame(width: 80, height: 80)
                        .overlay(
                            Text("No Image")
                                .foregroundColor(.white)
                                .font(.caption)
                        )
                }
                Spacer()
            }
            .padding(.horizontal)

            // Name and Bio
            VStack(alignment: .leading, spacing: 4) {
                if let fullname = user.fullname {
                    Text(fullname)
                        .font(.footnote)
                        .fontWeight(.semibold)
                }

                if let bio = user.bio {
                    Text(bio)
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)

            // Edit Profile Button
            Button {
                isEditing = true
            } label: {
                Text("Edit Profile")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .frame(width: 360, height: 32)
                    .foregroundColor(.black)
                    .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.gray, lineWidth: 1))
            }

            Divider()
        }
    }
}

import SwiftUI
import TipKit

struct ProfileHeaderView: View {
    @Bindable var user: User
    @Binding var isEditing: Bool

    var body: some View {
        VStack(spacing: 10) {
            // Profile Picture
            HStack {
                if let imageData = user.profileImageURL.flatMap({ Data(base64Encoded: $0) }),
                   let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())
                        .padding(.top, 70) // Adjust the padding to move the image lower
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

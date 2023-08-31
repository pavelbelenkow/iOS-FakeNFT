//
//  EditProfileViewModel.swift
//  FakeNFT
//
//  Created by D on 31.08.2023.
//

import Foundation

final class EditProfileViewModel {

    private var user: UserEditing?

    var newName: String?
    var newDesc: String?
    var newWebsite: String?

    var nameChanged: ((String?) -> Void)?
    var descriptionChanged: ((String?) -> Void)?
    var websiteChanged: ((String?) -> Void)?

    init() {
        subscribeForChanges()
    }

    func screenClosed() {
        guard
            let newName,
            let newDesc,
            let newWebsite
        else { return }
        user = UserEditing(name: newName,
                           description: newDesc,
                           website: newWebsite)
    }

    private func subscribeForChanges() {
        nameChanged = { [weak self] newText in
            self?.newName = newText
        }

        descriptionChanged = { [weak self] newText in
            self?.newDesc = newText
        }

        websiteChanged = { [weak self] newText in
            self?.newWebsite = newText
        }
    }

}

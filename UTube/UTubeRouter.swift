//
//  UTubeRouter.swift
//  UTube
//
//  Created by 百瀬篤志 on 2022/03/15.
//

import Foundation

protocol RepositorySearchResultWireframe: AnyObject {
    func showRepositoryDetail(_ repository: TextSearchedEntity)
}

class UTubeRouter {
}

extension UTubeRouter: RepositorySearchResultWireframe {
    func showRepositoryDetail(_ repository: TextSearchedEntity) {
        
    }
}

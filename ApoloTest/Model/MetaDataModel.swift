//
//  MetadataModel.swift
//  ApoloTest
//
//  Created by wilnin on 4/07/20.
//  Copyright © 2020 PersonalProject. All rights reserved.
//

import UIKit

public struct MetaDataModel: Codable {
    public var collection: Collection?
}

public struct Collection: Codable {
    public var items: [Items]?
    public var href: String?
    public var links: [Links]?
}

public struct Items: Codable {
    public var href: String?
    public var data: [DataItem]?
    public var links: [Links]?
}

public struct DataItem: Codable {
    public var keywords: [String]?
    public var description: String?
    public var title: String?
    public var date_created: String?
    public var center: String?
    public var media_type: String?
    public var nasa_id: String?
}

public struct Links: Codable {
    public var href: String?
}

public struct Hits: Codable {
    public var total_hits: Int?
}

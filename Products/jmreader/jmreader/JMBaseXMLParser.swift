//
//  JMBaseXMLParser.swift
//  jmreader
//
//  Created by meiliangjun1_vendor on 2020/10/13.
//  Copyright © 2020 meiliangjun1_vendor. All rights reserved.
//

import UIKit

protocol JMBaseXMLParserDelegate {
    func onParserItem(itemDict: [String: String])
    func onHandleParserItems() -> [Any]
}

protocol JMBaseXMLParserCallback: AnyObject {
    func parser(completed items: [Any])
}

class JMBaseXMLParser: NSObject, XMLParserDelegate, JMBaseXMLParserDelegate {
    func onHandleParserItems() -> [Any] {
        return []
    }
    
    
    var xmlTags: [String] = []
    var xmlParser: XMLParser? = nil
    var itemDict = [String: String]()
    var currentElement: String?
    weak var delegate: JMBaseXMLParserCallback?

    init(xmlData: Data) {
        xmlParser = XMLParser(data: xmlData)
        super.init()
        
        // config delegate
        xmlParser?.delegate = self
    }
    
    func prepareForParser() {
        let queue = DispatchQueue(label: "com.apple.parser.xml", attributes: .concurrent)
        queue.async {
            if let _ = self.xmlParser?.parse() {
                NSLog("解析xml中...")
            }
        }
    }
    
    // MARK: XMLParserDelegate
    func parserDidStartDocument(_ parser: XMLParser) {
        xmlTags.removeAll()
        NSLog("start parser document.")
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        NSLog("end parser document.")
        delegate?.parser(completed: onHandleParserItems())
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        xmlTags.append(elementName)
        
        currentElement = elementName
    }
    
    func parser(_ parser: XMLParser, foundCDATA CDATABlock: Data) {
        guard let elementName = currentElement else {
            return
        }
        guard let cdataString = String(data: CDATABlock, encoding: .utf8) else {
            return
        }
        
        itemDict[elementName] = cdataString
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        guard xmlTags.count >= 2 else {
            return
        }
        
        guard let elementName = currentElement, "item".elementsEqual(xmlTags[xmlTags.count - 2]) else {
            return
        }
        
        let str = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        guard str.count > 0 else {
            return
        }
        
        var elementValue = itemDict[elementName] ?? ""
        elementValue.append(str)
        
        itemDict[elementName] = elementValue
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        xmlTags.removeLast()
//        NSLog("elementName: %s, \nqualifiedName: %s, \nnamespaceURI: %s", elementName, qName ?? "", namespaceURI ?? "")
        if "item".elementsEqual(elementName) {
            // 当前item信息读取结束，传递给上层，如果不处理，那么就丢弃
            onParserItem(itemDict: itemDict)
            itemDict.removeAll()
        }
    }
    
    
    // MARK: JMBaseXMLParserDelegate
    
    func onParserItem(itemDict: [String : String]) {
        // do something
    }
}

class StatsGOVParser: JMBaseXMLParser {
    
    var items:[NewsDetail] = []
    
    override func onParserItem(itemDict: [String : String]) {
        guard let item = model(from: itemDict, type: NewsDetail.self) as? NewsDetail else {
            return
        }
        items.append(item)
    }
    
    override func onHandleParserItems() -> [Any] {
        return items
    }
}

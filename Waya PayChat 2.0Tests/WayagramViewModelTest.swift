//
//  WayagramViewModelTest.swift
//  Waya PayChat 2.0Tests
//
//  Created by Nwudo Anthony Chukwuebuka on 2/22/21.
//

import XCTest
@testable import Waya_PayChat_2_0

class WayagramViewModelTest : XCTestCase{
    
    var wayagramViewModel : WayagramViewModelImpl!
    var sut: URLSession!

    
    override func setUp() {
 
        continueAfterFailure = false
        sut = URLSession(configuration: .default)

        wayagramViewModel = WayagramViewModelImpl()

    }
    
    override func tearDown() {
        sut = nil
        wayagramViewModel = nil
        super.tearDown()
    }

    func test_fetchPost() throws{
        
    }
    
    
    func test_postSuccessfullyInit(){
        let post = PostResponse(id: "id", description: "Description", type: "user", parentID: nil, groupID: nil, pageID: nil, isDeleted: false, isPoll: false, createdAt: "2020-05-17", updatedAt: "2020-05-17", profile: PostProfilerResponse(), images: [], poll: nil, postion: 0, likesCount: 0, commentCount: 0, repostCount: 0)
        
        XCTAssertEqual(post.id, "id")
        XCTAssertEqual(post.type, "user")
    }
    
    func test_userPostPopulateWell(){
        let post1 = PostResponse()
        let post2 = PostResponse()
        
        wayagramViewModel.userPostResponse.append(post1)
        wayagramViewModel.userPostResponse.append(post2)
        XCTAssertEqual(wayagramViewModel.userPostResponse.count, 2)
    }
    
    func test_userPostCanBeUpdated(){
        let post = PostResponse(id: "id", description: "Description", type: "user", parentID: nil, groupID: nil, pageID: nil, isDeleted: false, isPoll: false, createdAt: "2020-05-17", updatedAt: "2020-05-17", profile: PostProfilerResponse(), images: [], poll: nil, postion: 0, likesCount: 0, commentCount: 0, repostCount: 0)
        
        wayagramViewModel.userPostResponse.append(post)
        wayagramViewModel.userPostResponse[0].description = "This description can be changed"
        XCTAssertEqual(wayagramViewModel.userPostResponse[0].description, "This description can be changed")
    }
    
    // Asynchronous test: success fast, failure slow
    func testValidBaseHTTPStatusCode200() {
        // given
        let url = 
            URL(string: "http://46.101.41.187:8059/")
        // 1
        let promise = expectation(description: "Status code: true")
        
        // when
        let dataTask = sut.dataTask(with: url!) { data, response, error in
            // then
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
                return
            } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if statusCode == 200 {
                    // 2
                    promise.fulfill()
                } else {
                    XCTFail("Status code: \(statusCode)")
                }
            }
        }
        dataTask.resume()
        // 3
        wait(for: [promise], timeout: 5)
        
        let testBundle = Bundle(for: type(of: self))
        let path = testBundle.path(forResource: "abbaData", ofType: "json")
        let data = try? Data(contentsOf: URL(fileURLWithPath: path!), options: .alwaysMapped)
        
    }

    
    
}


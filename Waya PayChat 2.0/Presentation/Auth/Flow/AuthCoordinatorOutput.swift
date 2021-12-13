//
//  AuthCoordinatorOutput.swift
//  Waya PayChat 2.0
//
//  Created by Dayob Banjo on 3/2/21.
//

protocol AuthCoordinatorOutput: class {
    var finishFlow: (() -> Void)? { get set }
}


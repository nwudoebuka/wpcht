//
//  OnboardingCoordinatorOutput.swift
//  Waya PayChat 2.0
//
//  Created by Dayo Banjo on 3/2/21.
//

protocol OnboardingCoordinatorOutput: class {
    var finishFlow: (() -> Void)? { get set }
}

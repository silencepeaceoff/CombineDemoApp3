//
//  ViewController.swift
//  CombineDemoApp3
//
//  Created by Dmitrii Tikhomirov on 6/2/23.
//

import UIKit
import Combine

final class ViewController: UIViewController {

  private let contentImgVw: UIImageView = {
    let imgVw = UIImageView()
    imgVw.clipsToBounds = true
    imgVw.contentMode = .scaleAspectFill
    imgVw.backgroundColor = .systemGray4
    imgVw.layer.cornerRadius = 8
    imgVw.translatesAutoresizingMaskIntoConstraints = false
    return imgVw
  }()

  private let downloadBtn: UIButton = {
    let btn = UIButton()
    btn.setTitle("Download", for: .normal)
    btn.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
    btn.backgroundColor = .systemBlue
    btn.layer.cornerRadius = 8
    btn.translatesAutoresizingMaskIntoConstraints = false
    btn.addTarget(self, action: #selector(downloadDidTouch), for: .touchUpInside)
    return btn
  }()

  private let contentContainerStackVww: UIStackView = {
    let stackVw = UIStackView()
    stackVw.spacing = 16
    stackVw.axis = .vertical
    stackVw.distribution = .fillProportionally
    stackVw.translatesAutoresizingMaskIntoConstraints = false
    return stackVw
  }()

  private let imgLink =
  "https://blueprint-api-production.s3.amazonaws.com/uploads/story/thumbnail/121489/11a49146-03e6-4f02-8c30-ac3454a1b54b.png"

  private var subscriptions = Set<AnyCancellable>()
  private let imgDownloaderViewModel = ImageDownloaderViewModel()

  override func loadView() {
    super.loadView()

    setup()
    setupImgSubscription()
  }

  @objc func downloadDidTouch() {
    imgDownloaderViewModel.download(url: imgLink)
  }

}

extension ViewController {

  private func setup() {
    view.backgroundColor = .systemBackground

    contentContainerStackVww.addArrangedSubview(contentImgVw)
    contentContainerStackVww.addArrangedSubview(downloadBtn)

    view.addSubview(contentContainerStackVww)

    let h = view.frame.width / 16 * 9

    NSLayoutConstraint.activate([

      contentImgVw.heightAnchor.constraint(equalToConstant: h),
      downloadBtn.heightAnchor.constraint(equalToConstant: 44),

      contentContainerStackVww.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      contentContainerStackVww.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
      contentContainerStackVww.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
      contentContainerStackVww.heightAnchor.constraint(equalToConstant: 60 + h)
    ])
  }

  func setupImgSubscription() {

    imgDownloaderViewModel
      .image
      .assign(to: \.image, on: contentImgVw)
      .store(in: &subscriptions)
  }
}

//
//  SelectButton.swift
//  MyPlaygrounds
//
//  Created by Dmitry on 13.05.2022.
//

import UIKit
import PinLayout

final class SelectButton: UIView {
    var dropDownHidden = true {
        didSet {
            guard dropDownHidden != tableView.isHidden else { return }
            self.setNeedsLayout()
        }
    }
    
    var items: [String] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    var touchUpInside: (() -> Void)? = nil
    var itemSelected: ((Int) -> Void)? = nil
    
    var label: String? {
        didSet {
            textLabel.text = label
        }
    }
    
    var iconImage: UIImage? {
        didSet {
            icon.image = iconImage
        }
    }
    
    private let container: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor("333333")
//        view.layer.cornerRadius = .cornerRadius
        return view
    }()
    
    lazy var icon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = iconImage
        return imageView
    }()
    
    let arrowIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "down-arrow")
        return imageView
    }()
    
    lazy var textLabel: UILabel = {
        let label = UILabel()
//        label.font = UIFont.Assistant.regular(15)
        label.text = self.label
        label.textColor = UIColor("A3A3A3")
        label.textAlignment = .left
        return label
    }()
    
    let button: UIButton = {
        let button = UIButton()
        return button
    }()
    
    let tableView: UITableView = {
        let table = UITableView()
//        table.layer.cornerRadius = .cornerRadius
        return table
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        backgroundColor = .clear
        addSubview(container)
        container.addSubviews(icon, arrowIcon, textLabel, button)
        
        tableView.register(DropDownItemCell.self, forCellReuseIdentifier: String(describing: DropDownItemCell.self))
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureSubviews()
        
        tableView.backgroundColor = UIColor("3C3C3C")
        
        if dropDownHidden {
            tableView.isHidden = true
            let frame = CGRect(origin: tableView.frame.origin,
                               size: CGSize(width: tableView.frame.width, height: 0))
            
            tableView.frame = frame
        } else {
            configureTableIfNeeded()
            tableView.isHidden = false
            let frame = CGRect(origin: tableView.frame.origin,
                               size: CGSize(width: tableView.frame.width, height: tableView.contentSize.height))
            
            tableView.frame = frame
        }
        
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    private func configureSubviews() {
        container.pin
            .all()
        
        icon.pin
            .vCenter()
            .left(5)
            .size(25)
        
        arrowIcon.pin
            .vCenter()
            .right(5)
            .sizeToFit()
        
        textLabel.pin
            .after(of: icon)
            .marginLeft(5)
            .before(of: arrowIcon)
            .marginRight(5)
            .vCenter()
            .sizeToFit(.width)
        
        button.pin
            .all()
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var size = size
        pin.size(size)
        configureSubviews()
        size.height = max(icon.frame.height, textLabel.frame.height) + 24
        return size
    }
    
    @objc
    private func buttonTapped() {
        touchUpInside?()
    }
    
    private func configureTableIfNeeded() {
        guard superview?.subviews.first(where: { $0 == tableView }) == nil else { return }
        superview?.addSubview(tableView)
        tableView.pin
            .below(of: container)
            .left(to: container.edge.left)
            .marginTop(5)
            .width(of: container)
            .height(0)
    }
}

extension SelectButton: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: DropDownItemCell.self), for: indexPath) as? DropDownItemCell {
            cell.label.text = items[indexPath.item]
            return cell
        }
        return tableView.dequeueReusableCell(withIdentifier: String(describing: DropDownItemCell.self), for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
}

extension SelectButton: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemSelected?(indexPath.item)
    }
}

class DropDownItemCell: UITableViewCell {
    let container: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    let label: UILabel = {
        let label = UILabel()
//        label.font = UIFont.Assistant.regular(15)
        label.text = "Test item"
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSubviews() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        contentView.addSubview(container)
        container.addSubviews(label)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        configureSubviews()
    }

    private func configureSubviews() {
        container.pin
            .all()
        
        label.pin
            .left(25)
            .right()
            .vCenter()
            .sizeToFit(.width)
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var size = size
        container.pin
            .width(size.width)
        configureSubviews()
        size.height = container.frame.height
        return size
    }
}

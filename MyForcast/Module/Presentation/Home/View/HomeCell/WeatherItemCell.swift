//
//  WeatherItemCell.swift
//  MyForcast
//
//  Created by walid on 25/9/2022.
//

import UIKit

protocol WeatherItemCellDelegate: AnyObject {
    func onClickItemCell(model: WeatherResponse?)
}

class WeatherItemCell: UITableViewCell {

    @IBOutlet weak var lbCityName: UILabel!
    @IBOutlet weak var lbDistrictName: UILabel!
    @IBOutlet weak var lbTempView: UILabel!
    @IBOutlet weak var lbTimeView: UILabel!
    @IBOutlet weak var imgIconWeather: UIImageView!
    
    static let nibName: String = "WeatherItemCell"
    
    weak var delegate: WeatherItemCellDelegate?
    
    var model: WeatherResponse?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func initView(model: WeatherResponse) {
        self.model = model
        self.lbCityName.text = self.model?.cityName ?? ""
        self.lbDistrictName.text = self.model?.districtName ?? ""
        let windSpeed = model.current?.windSpeed ?? 0
        self.lbTimeView.text = "\(windSpeed) mph"
        self.lbTempView.text = "\(self.model?.current?.temp ?? 0)° C"
        if let firstWeather = self.model?.current?.weather.first {
            let iconName = firstWeather.icon ?? ""
            let imgPath = Constants.pathImgIcon.replacingOccurrences(of: "**_**", with: iconName)
            let img = UIImage(named: iconName)
            guard let url = URL(string: imgPath),
                  img == nil else {
                self.imgIconWeather.image = img
                return
            }
            self.imgIconWeather.load(url: url)
        }
        
        self.contentView.setOnClickListener(target: self, action: #selector(onClickCell))
    }
    
    @objc func onClickCell(_ tap: UITapGestureRecognizer) {
        self.delegate?.onClickItemCell(model: self.model)
    
    }
    
    /*
     get Nib of Cell
     */
    static func nib() -> UINib {
        return UINib(nibName: WeatherItemCell.nibName, bundle: nil)
    }
    
}

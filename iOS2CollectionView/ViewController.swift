//
//  ViewController.swift
//  iOS2CollectionView
//
//  Created by lpiem on 09/03/2022.
//

import UIKit

class ViewController: UICollectionViewController {
    
    var landmarks : [Landmark] = []
    
    enum Section{
        case main
//        case category
//        case favorite
    }
    
    enum Item: Hashable{
        case landmark(Landmark)
    }
    
    var diffableDataSource: UICollectionViewDiffableDataSource<Section, Item>!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        landmarks = DataManager.sharedInstance.getData(forName: "landmarkData")
        print(landmarks[0].name)
        
        configureDataSource()
        collectionView.collectionViewLayout = createLayout()
        loadInitialState()
    }

    private func configureDataSource(){
        diffableDataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { [weak self] collectionView, indexPath, itemIdentifier in
            guard let self = self else{
                return nil
            }
            switch itemIdentifier{
            case .landmark:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! LandmarkItemCell
                cell.contentView.backgroundColor = UIColor.purple
                cell.image.image = self.landmarks[indexPath.hashValue].image
                cell.title.text = self.landmarks[indexPath.hashValue].name
                return cell
            }
        })
    }
    
    private func createSnapshot() -> NSDiffableDataSourceSnapshot<Section, Item>{
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
       
        let items = landmarks.map { Item.landmark($0) }
        
        snapshot.appendItems(items, toSection: .main)
        
        return snapshot
    }
    
    private func loadInitialState(){
        let snapshot = createSnapshot()
        diffableDataSource.apply(snapshot)
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout{
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, collectionLayoutEnvironment in
            guard let self = self,
                  let section = self.diffableDataSource.sectionIdentifier(for: sectionIndex) else {
                return nil
            }
            
            switch section{
            case .main:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                      heightDimension: .fractionalHeight(1))
                
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(100),
                                                       heightDimension: .absolute(100))
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                               subitem: item,
                                                               count: 1)
                
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.interGroupSpacing = 8
                return section
            }
        }
        return layout
    }
    
}


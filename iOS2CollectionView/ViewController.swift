//
//  ViewController.swift
//  iOS2CollectionView
//
//  Created by lpiem on 09/03/2022.
//

import UIKit

class ViewController: UICollectionViewController {
        
    var landmark : [Landmark] = []
    
    enum Section{
//        case main
        case rivers
        case lakes
        case mountains
        case favorite
    }
    
    enum Item: Hashable{
        case landmarkFav(Landmark)
        case landmarkRivers(Landmark)
        case landmarkMountains(Landmark)
        case landmarkLakes(Landmark)

    }
    
    var diffableDataSource: UICollectionViewDiffableDataSource<Section, Item>!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(UINib(nibName: "HeaderCollectionReusableView", bundle: nil),
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: "HeaderCollectionReusableView")
        
        collectionView.register(UINib(nibName: "Header2CollectionReusableView", bundle: nil),
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: "Header2CollectionReusableView")
        
        // Do any additional setup after loading the view.
        landmark = DataManager.sharedInstance.getData(forName: "landmarkData")
        
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
            case .landmarkFav:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "favCell", for: indexPath) as! LandmarkFavItemCell
                cell.configure(landmark: DataManager.sharedInstance.getFavorite()[indexPath.item])
                if(self.view.traitCollection.horizontalSizeClass == .regular){
                    cell.photo.layer.cornerRadius = 15
                }
                return cell
            
            case .landmarkLakes:
                return self.createCategoryCell(category: .lakes, indexPath: indexPath)
            case .landmarkRivers:
                return self.createCategoryCell(category: .rivers, indexPath: indexPath)
            case .landmarkMountains:
                return self.createCategoryCell(category: .mountains, indexPath: indexPath)
            }
            
        })
        
        diffableDataSource.supplementaryViewProvider = { collectionView, elementKind, indexPath in
            switch elementKind{
            case UICollectionView.elementKindSectionHeader:
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: elementKind,
                                                                             withReuseIdentifier: "HeaderCollectionReusableView",
                                                                             for: indexPath) as! HeaderCollectionReusableView
                
                switch indexPath{
                case[0,0]:
                    header.title.text = "Favorites"
                case [1,0]:
                        header.title.text = "Lakes"
                case [2,0]:
                        header.title.text = "Rivers"
                case [3,0]:
                        header.title.text = "Mountains"
                default:
                    break
                }
    
              
                return header
            default:
                return nil
            }
            
        }
        
    }
    
    private func createCategoryCell(category: Landmark.Category, indexPath: IndexPath) -> LandmarkCategoryItemCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as! LandmarkCategoryItemCell
        cell.configure(landmark: DataManager.sharedInstance.getCategory(category: category)[indexPath.item])
        return cell
    }
    
    private func createSnapshot() -> NSDiffableDataSourceSnapshot<Section, Item>{
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.favorite, .lakes, .rivers, .mountains])
       
        let favorites = DataManager.sharedInstance.getFavorite().map { Item.landmarkFav($0) }
        
        let rivers = DataManager.sharedInstance.getCategory(category: .rivers).map { Item.landmarkRivers($0) }
        let mountains = DataManager.sharedInstance.getCategory(category: .mountains).map { Item.landmarkMountains($0) }
        let lakes = DataManager.sharedInstance.getCategory(category: .lakes).map { Item.landmarkLakes($0) }
        

        snapshot.appendItems(favorites, toSection: .favorite)
        snapshot.appendItems(rivers, toSection: .rivers)
        snapshot.appendItems(mountains, toSection: .mountains)
        snapshot.appendItems(lakes, toSection: .lakes)
        
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
            case .favorite:
                    let formatRegular = self.view.traitCollection.horizontalSizeClass == .regular
                    
                    let itemSize = NSCollectionLayoutSize(widthDimension: formatRegular ? .fractionalWidth(0.5) : .fractionalWidth(1),
                                                          heightDimension: .absolute(250))
                    
                    let item = NSCollectionLayoutItem(layoutSize: itemSize)
                    
                    let groupSize = NSCollectionLayoutSize(widthDimension: formatRegular ? .fractionalWidth(0.5) : .fractionalWidth(1),
                                                           heightDimension: .absolute(250))
                    
                    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                                   subitem: item,
                                                                   count: 1)
                    
                    if(formatRegular){
                        group.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 16)
                    }
                    
                    let section = NSCollectionLayoutSection(group: group)
                    let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: formatRegular ? .fractionalHeight(0.10) : .absolute(50))
                    let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
                    
                    
                    section.orthogonalScrollingBehavior = .groupPaging
                    if(formatRegular){
                        section.contentInsets = .init(top: 0, leading: 16, bottom: 28, trailing: 0)
                    }else{
                        section.contentInsets.bottom = 28

                    }
                    section.boundarySupplementaryItems = [header]
                    return section
            
            case .lakes, .mountains, .rivers:
                return self.createCategoryLayout()
            }
        }
        return layout
    }
    
    private func createCategoryLayout() -> NSCollectionLayoutSection{
        
            let formatRegular = self.view.traitCollection.horizontalSizeClass == .regular
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(130),
                                                  heightDimension: formatRegular ? .absolute(312) : .absolute(150))
            
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(130),
                                                   heightDimension: formatRegular ? .absolute(312) : .absolute(150))
            
            let group : NSCollectionLayoutGroup
            if(formatRegular){
                group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize,
                                                               subitem: item,
                                                               count: 2)
            }else{
                group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                               subitem: item,
                                                               count: 1)
            }
            
            let section = NSCollectionLayoutSection(group: group)
            
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: formatRegular ? .fractionalHeight(0.10) : .absolute(50))
            let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)

            section.orthogonalScrollingBehavior = .continuous
            section.interGroupSpacing = 12
            section.contentInsets = .init(top: 0, leading: 12, bottom: 32, trailing: 12)
            section.boundarySupplementaryItems = [header]

            return section
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "detail"){
            let destination = segue.destination as!  DetailViewController
            let cell = sender as! UICollectionViewCell
            guard let index = collectionView.indexPath(for: cell),
                  let item = diffableDataSource.itemIdentifier(for: index) else{
                    return
                }
            switch item{
            case .landmarkFav(let landmark), .landmarkMountains(let landmark), .landmarkRivers(let landmark), .landmarkLakes(let landmark):
                destination.landmark = landmark
            }
        }
    }
    
}

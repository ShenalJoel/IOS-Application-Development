import SwiftUI

struct CategoryListView: View {
    @StateObject private var viewModel = CategoryViewModel()
    //@State private var selectedCategory: Category? = nil
    //@State private var redirectToProducts = false
    @Binding var selectedCategory: Category?
    @Binding var redirectToProducts: Bool
    private let itemsPerRow = 5
    private let gridLayout = Array(repeating: GridItem(.flexible()), count: 5) // 5 items per row
    private let maxRowsPerPage = 3
    private let rowHeight: CGFloat = 80 // Adjust based on your cell size
    private let verticalSpacing: CGFloat = 10 // Adjust based on your grid's vertical spacing
    private let pagePadding: CGFloat = 40 // Adjust if your page has top and bottom padding
    
    var body: some View {
        TabView {
            ForEach(0..<numberOfPages(), id: \.self) { pageIndex in
                pageView(pageIndex: pageIndex)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .automatic))
        .frame(height: dynamicHeight())
        .onAppear {
            viewModel.fetchCategories()
        }
    }
    
    private func pageView(pageIndex: Int) -> some View {
        let page = getPage(at: pageIndex)
        
        return LazyVGrid(columns: gridLayout, spacing: verticalSpacing) {
            ForEach(page, id: \.id) { category in
                VStack {
                    CategoryChip(category: category.name, imageName: category.imageName, isSelected: category == selectedCategory)
                        .onTapGesture {
                            selectedCategory = (selectedCategory == category) ? nil : category
                            redirectToProducts = true
                        }
                    Text(category.name)
                        .font(.caption)
                        .frame(width: 60)
                }
            }
        }
        .padding(.horizontal)
    }
    
    private func numberOfPages() -> Int {
        return pagedCategories().count
    }
    
    private func getPage(at index: Int) -> [Category] {
        let pages = pagedCategories()
        return pages.count > index ? pages[index] : []
    }
    
    private func pagedCategories() -> [[Category]] {
        let itemsPerPage = itemsPerRow * maxRowsPerPage
        return viewModel.categories.chunked(into: itemsPerPage)
    }
    
    private func dynamicHeight() -> CGFloat {
        // Each page should have a uniform height based on max rows
        return CGFloat(maxRowsPerPage) * rowHeight + (CGFloat(maxRowsPerPage) - 1) * verticalSpacing + pagePadding
    }
}


// Extension remains the same
extension Array {
    func chunked(into size: Int) -> [[Element]] {
        stride(from: 0, to: count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, count)])
        }
    }
}

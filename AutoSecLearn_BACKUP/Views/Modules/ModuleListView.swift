import SwiftUI

struct ModuleListView: View {
    @Environment(UserProgressManager.self) var progressManager
    @State private var searchText = ""

    private let modules = CourseContent.modules

    private var filteredModules: [LearningModule] {
        if searchText.isEmpty {
            return modules
        }
        return modules.filter {
            $0.title.localizedCaseInsensitiveContains(searchText) ||
            $0.description.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(filteredModules) { module in
                        NavigationLink {
                            ModuleDetailView(module: module)
                        } label: {
                            ModuleCard(
                                module: module,
                                progress: progressManager.moduleProgress(for: module)
                            )
                        }
                        .buttonStyle(.plain)
                    }

                    if filteredModules.isEmpty {
                        VStack(spacing: 12) {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 40))
                                .foregroundStyle(.secondary)
                            Text("No modules found")
                                .font(.headline)
                                .foregroundStyle(.secondary)
                            Text("Try a different search term")
                                .font(.subheadline)
                                .foregroundStyle(.tertiary)
                        }
                        .padding(.top, 60)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Modules")
            .searchable(text: $searchText, prompt: "Search modules...")
        }
    }
}

#Preview {
    ModuleListView()
        .environment(UserProgressManager())
        .environment(SoundManager())
}

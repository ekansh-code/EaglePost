import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'view_model_home.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeViewModel(),
      child: const _HomePageContent(),
    );
  }
}

class _HomePageContent extends StatelessWidget {
  const _HomePageContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Record Pagination'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Consumer<HomeViewModel>(
              builder: (context, viewModel, child) {
                return TextField(
                  decoration: InputDecoration(
                    labelText: 'Search by Name',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: viewModel.searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              viewModel.clearSearch();
                            },
                          )
                        : null,
                  ),
                  onChanged: (value) => viewModel.searchRecords(value),
                );
              },
            ),
          ),
          Expanded(
            child: Consumer<HomeViewModel>(
              builder: (context, viewModel, child) {
                if (viewModel.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (viewModel.displayedRecords.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.search_off,
                          size: 64,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          viewModel.searchQuery.isEmpty 
                              ? 'No records available'
                              : 'No records found for "${viewModel.searchQuery}"',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                        if (viewModel.searchQuery.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () => viewModel.clearSearch(),
                            icon: const Icon(Icons.clear),
                            label: const Text('Clear Search'),
                          ),
                        ],
                      ],
                    ),
                  );
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      color: Colors.grey,
                      height: 50,
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text('Sr', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Name', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Email', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Age', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('City', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('State', style: TextStyle(fontWeight: FontWeight.bold))),
                        ],
                        rows: const [],
                      ),
                    ),
                    // Scrollable Content
                    Expanded(
                      child: SingleChildScrollView(
                        child: DataTable(
                          columnSpacing: 20.0,
                          headingRowHeight: 0,
                          columns: const [
                            DataColumn(label: SizedBox.shrink()),
                            DataColumn(label: SizedBox.shrink()),
                            DataColumn(label: SizedBox.shrink()),
                            DataColumn(label: SizedBox.shrink()),
                            DataColumn(label: SizedBox.shrink()),
                            DataColumn(label: SizedBox.shrink()),
                          ],
                          rows: viewModel.displayedRecords.map((record) {
                            int index = viewModel.displayedRecords.indexOf(record);
                            return DataRow(
                              cells: [
                                DataCell(Text(
                                  viewModel.searchQuery.isEmpty
                                      ? '${(viewModel.currentPage - 1) * 50 + index + 1}'
                                      : '${viewModel.filteredRecords.indexOf(record) + 1}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold, color: Colors.redAccent),
                                )),
                                DataCell(Text(record.name)),
                                DataCell(Text(record.email)),
                                DataCell(Text(record.age.toString())),
                                DataCell(Text(record.city)),
                                DataCell(Text(record.state)),
                              ],
                              color: WidgetStateProperty.all(
                                index.isEven ? Colors.grey[200] : Colors.white,
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Consumer<HomeViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.displayedRecords.isEmpty) return const SizedBox();

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: viewModel.canGoBack ? viewModel.previousPage : null,
                  icon: const Icon(Icons.arrow_back_ios_new_sharp, size: 32),
                ),
                const SizedBox(width: 20),
                Text(viewModel.displayRange),
                const SizedBox(width: 20),
                IconButton(
                  onPressed: viewModel.canGoForward ? viewModel.nextPage : null,
                  icon: const Icon(Icons.arrow_forward_ios, size: 32),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

import 'package:get/get.dart';
import '../../domain/entities/support_ticket_entity.dart';
import '../../domain/repositories/support_ticket_repository.dart';

class SupportTicketsController extends GetxController {
  final SupportTicketRepository _repository;
  SupportTicketsController(this._repository);

  final RxList<SupportTicketEntity> tickets = <SupportTicketEntity>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  final RxString statusFilter = 'all'.obs;
  final RxString categoryFilter = 'all'.obs;
  final RxString searchQuery = ''.obs;

  final RxInt totalCount = 0.obs;
  int _currentPage = 1;
  static const _limit = 15;

  // Stats
  final RxInt openCount = 0.obs;
  final RxInt escalatedCount = 0.obs;
  final RxInt closedCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _loadStats();
    fetchTickets(isRefresh: true);
  }

  Future<void> _loadStats() async {
    openCount.value = await _repository.getTotalCount(statusFilter: 'open');
    escalatedCount.value = await _repository.getTotalCount(statusFilter: 'escalated');
    closedCount.value = await _repository.getTotalCount(statusFilter: 'closed');
  }

  void applyStatusFilter(String status) {
    statusFilter.value = status;
    fetchTickets(isRefresh: true);
  }

  void applySearch(String q) {
    searchQuery.value = q;
    fetchTickets(isRefresh: true);
  }

  Future<void> fetchTickets({bool isRefresh = false}) async {
    if (isLoading.value) return;
    try {
      if (isRefresh) {
        _currentPage = 1;
        tickets.clear();
      }
      isLoading.value = true;
      error.value = '';
      final data = await _repository.getTickets(
        page: _currentPage,
        limit: _limit,
        statusFilter: statusFilter.value == 'all' ? null : statusFilter.value,
        categoryFilter: categoryFilter.value == 'all' ? null : categoryFilter.value,
        searchQuery: searchQuery.value.isEmpty ? null : searchQuery.value,
      );
      totalCount.value = await _repository.getTotalCount(
        statusFilter: statusFilter.value == 'all' ? null : statusFilter.value,
      );
      if (isRefresh) {
        tickets.value = data;
      } else {
        tickets.addAll(data);
      }
      _currentPage++;
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}

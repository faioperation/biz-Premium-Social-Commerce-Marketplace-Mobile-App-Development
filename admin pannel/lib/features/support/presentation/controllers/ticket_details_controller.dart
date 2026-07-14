import 'package:get/get.dart';
import '../../domain/entities/support_ticket_entity.dart';
import '../../domain/repositories/support_ticket_repository.dart';

class TicketDetailsController extends GetxController {
  final SupportTicketRepository _repository;
  TicketDetailsController(this._repository);

  final Rx<SupportTicketEntity?> ticket = Rx<SupportTicketEntity?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isReplying = false.obs;
  final RxBool isActing = false.obs;
  final RxString error = ''.obs;

  Future<void> loadTicket(String id) async {
    try {
      isLoading.value = true;
      error.value = '';
      ticket.value = await _repository.getTicketDetails(id);
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> replyToTicket(String ticketId, String message) async {
    if (message.trim().isEmpty) return false;
    try {
      isReplying.value = true;
      await _repository.replyToTicket(ticketId, message, []);
      await loadTicket(ticketId);
      return true;
    } catch (e) {
      error.value = e.toString();
      return false;
    } finally {
      isReplying.value = false;
    }
  }

  Future<void> resolveTicket() async {
    final id = ticket.value?.id;
    if (id == null) return;
    try {
      isActing.value = true;
      await _repository.resolveTicket(id);
      await loadTicket(id);
    } finally {
      isActing.value = false;
    }
  }

  Future<void> escalateTicket() async {
    final id = ticket.value?.id;
    if (id == null) return;
    try {
      isActing.value = true;
      await _repository.escalateTicket(id);
      await loadTicket(id);
    } finally {
      isActing.value = false;
    }
  }

  Future<void> closeTicket() async {
    final id = ticket.value?.id;
    if (id == null) return;
    try {
      isActing.value = true;
      await _repository.closeTicket(id);
      await loadTicket(id);
    } finally {
      isActing.value = false;
    }
  }

  Future<void> assignTicket(String adminId, String adminName) async {
    final id = ticket.value?.id;
    if (id == null) return;
    try {
      isActing.value = true;
      await _repository.assignTicket(id, adminId, adminName);
      await loadTicket(id);
    } finally {
      isActing.value = false;
    }
  }

  Future<void> approveRefund() async {
    final id = ticket.value?.id;
    if (id == null) return;
    try {
      isActing.value = true;
      await _repository.approveRefund(id);
      await loadTicket(id);
    } finally {
      isActing.value = false;
    }
  }

  Future<void> rejectRefund(String reason) async {
    final id = ticket.value?.id;
    if (id == null) return;
    try {
      isActing.value = true;
      await _repository.rejectRefund(id, reason);
      await loadTicket(id);
    } finally {
      isActing.value = false;
    }
  }
}

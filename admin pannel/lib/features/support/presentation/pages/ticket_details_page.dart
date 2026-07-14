import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/services/currency_formatter.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_loader.dart';
import '../../../../core/widgets/app_status_chip.dart';
import '../../../../core/widgets/app_confirmation_dialog.dart';
import '../../domain/entities/support_ticket_entity.dart';
import '../../domain/entities/ticket_message_entity.dart';
import '../../domain/entities/refund_evidence_entity.dart';
import '../controllers/ticket_details_controller.dart';
import '../controllers/support_tickets_controller.dart';

class TicketDetailsPage extends StatefulWidget {
  final String ticketId;
  const TicketDetailsPage({super.key, required this.ticketId});

  @override
  State<TicketDetailsPage> createState() => _TicketDetailsPageState();
}

class _TicketDetailsPageState extends State<TicketDetailsPage> {
  late final TicketDetailsController controller;
  final _replyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller = Get.find<TicketDetailsController>();
    controller.loadTicket(widget.ticketId);
  }

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value && controller.ticket.value == null) {
        return const Center(child: AppLoader());
      }

      final ticket = controller.ticket.value;
      if (ticket == null) {
        return const Center(child: Text('Ticket not found'));
      }

      return SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.contentPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => context.pop(),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(ticket.subject, style: AppTextStyles.h2),
                      Text(
                        'Ticket #${ticket.id.replaceAll('ticket_', '')} · ${ticket.category} · ${ticket.userName}',
                        style: AppTextStyles.bodySm.copyWith(color: (Theme.of(context).brightness == Brightness.dark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight)),
                      ),
                    ],
                  ),
                ),
                _buildStatusChip(ticket.status),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left: Conversation + Reply
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      _buildConversationCard(ticket),
                      const SizedBox(height: AppSpacing.lg),
                      _buildReplyCard(ticket),
                      if (ticket.hasRefund) ...[
                        const SizedBox(height: AppSpacing.lg),
                        _buildRefundCard(ticket),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.xl),
                // Right: Actions + Info
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      _buildTicketInfoCard(ticket),
                      const SizedBox(height: AppSpacing.lg),
                      _buildActionsCard(ticket),
                      const SizedBox(height: AppSpacing.lg),
                      _buildAssignCard(ticket),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  // ──────────────────────────── Conversation ────────────────────────────

  Widget _buildConversationCard(SupportTicketEntity ticket) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.chat_bubble_outline, color: AppColors.primary),
              const SizedBox(width: AppSpacing.sm),
              Text('Conversation', style: AppTextStyles.h4),
              const Spacer(),
              Text(
                '${ticket.messages.length} message${ticket.messages.length == 1 ? '' : 's'}',
                style: AppTextStyles.bodySm.copyWith(color: (Theme.of(context).brightness == Brightness.dark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight)),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          const Divider(),
          const SizedBox(height: AppSpacing.md),
          ...ticket.messages.map((msg) => _buildMessageBubble(msg)),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(TicketMessageEntity msg) {
    final isAdmin = msg.isAdmin;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          CircleAvatar(
            radius: 18,
            backgroundColor: isAdmin ? AppColors.primary : AppColors.backgroundLight,
            child: Icon(
              isAdmin ? Icons.support_agent : Icons.person,
              size: 18,
              color: isAdmin ? Colors.white : (Theme.of(context).brightness == Brightness.dark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      msg.senderName,
                      style: AppTextStyles.bodySm.copyWith(fontWeight: FontWeight.w600),
                    ),
                    if (isAdmin) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text('Admin', style: AppTextStyles.bodySm.copyWith(color: AppColors.primary, fontSize: 10)),
                      ),
                    ],
                    const Spacer(),
                    Text(
                      DateFormat('MMM d, h:mm a').format(msg.createdAt),
                      style: AppTextStyles.bodySm.copyWith(color: (Theme.of(context).brightness == Brightness.dark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight), fontSize: 11),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: isAdmin
                        ? AppColors.primary.withValues(alpha: 0.06)
                        : AppColors.backgroundLight,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isAdmin ? AppColors.primary.withValues(alpha: 0.15) : (Theme.of(context).brightness == Brightness.dark ? AppColors.borderDark : AppColors.borderLight),
                    ),
                  ),
                  child: Text(msg.message, style: AppTextStyles.body.copyWith(height: 1.5)),
                ),
                if (msg.attachmentUrls.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Wrap(
                    spacing: 8,
                    children: msg.attachmentUrls.map((url) => _buildAttachmentChip(url)).toList(),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttachmentChip(String url) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.infoSubtle,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.info.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.attach_file, size: 14, color: AppColors.info),
          const SizedBox(width: 4),
          Text('Attachment', style: AppTextStyles.bodySm.copyWith(color: AppColors.info)),
        ],
      ),
    );
  }

  // ──────────────────────────── Reply Box ────────────────────────────

  Widget _buildReplyCard(SupportTicketEntity ticket) {
    final canReply = ticket.status != 'closed';
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.reply, color: AppColors.primary),
              const SizedBox(width: AppSpacing.sm),
              Text('Reply', style: AppTextStyles.h4),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          if (!canReply) ...[
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.backgroundLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'This ticket is closed and cannot receive new replies.',
                style: AppTextStyles.body.copyWith(color: (Theme.of(context).brightness == Brightness.dark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight)),
              ),
            ),
          ] else ...[
            TextField(
              controller: _replyController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Type your reply...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                filled: true,
                fillColor: AppColors.backgroundLight,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Obx(() => AppButton(
                  label: 'Send Reply',
                  icon: Icons.send,
                  isLoading: controller.isReplying.value,
                  onPressed: () async {
                    final msg = _replyController.text.trim();
                    if (msg.isEmpty) return;
                    final ok = await controller.replyToTicket(ticket.id, msg);
                    if (ok) {
                      _replyController.clear();
                      Get.find<SupportTicketsController>().fetchTickets(isRefresh: true);
                    }
                  },
                )),
              ],
            ),
          ],
        ],
      ),
    );
  }

  // ──────────────────────────── Refund Card ────────────────────────────

  Widget _buildRefundCard(SupportTicketEntity ticket) {
    final refundStatus = ticket.refundStatus ?? 'pending_review';
    final isPending = refundStatus == 'pending_review';
    final isApproved = refundStatus == 'approved';

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.receipt_long, color: AppColors.warning),
              const SizedBox(width: AppSpacing.sm),
              Text('Refund Request', style: AppTextStyles.h4),
              const Spacer(),
              _buildRefundStatusChip(refundStatus),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _infoRow('Order ID', ticket.orderId ?? '-'),
          const SizedBox(height: AppSpacing.sm),
          _infoRow('Refund Amount', CurrencyFormatter.format(ticket.refundAmount ?? 0)),
          const SizedBox(height: AppSpacing.lg),
          Text('Evidence Submitted', style: AppTextStyles.h5),
          const SizedBox(height: AppSpacing.md),
          ...ticket.refundEvidence.map((ev) => _buildEvidenceCard(ev)),
          if (isPending) ...[
            const SizedBox(height: AppSpacing.lg),
            const Divider(),
            const SizedBox(height: AppSpacing.md),
            Text('Admin Decision', style: AppTextStyles.h5),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    label: 'Approve Refund',
                    onPressed: () => AppConfirmationDialog.show(
                      context,
                      title: 'Approve Refund',
                      content: 'Are you sure you want to approve a refund of ${CurrencyFormatter.format(ticket.refundAmount ?? 0)}?',
                      confirmText: 'Approve',
                      onConfirm: () {
                        controller.approveRefund();
                        Get.find<SupportTicketsController>().fetchTickets(isRefresh: true);
                      },
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: AppButton(
                    label: 'Reject Refund',
                    type: AppButtonType.outline,
                    onPressed: () => AppConfirmationDialog.show(
                      context,
                      title: 'Reject Refund',
                      content: 'Are you sure you want to reject this refund request?',
                      confirmText: 'Reject',
                      onConfirm: () {
                        controller.rejectRefund('Insufficient evidence');
                        Get.find<SupportTicketsController>().fetchTickets(isRefresh: true);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
          if (isApproved) ...[
            const SizedBox(height: AppSpacing.md),
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.successSubtle,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: AppColors.success),
                  const SizedBox(width: AppSpacing.sm),
                  Text('Refund has been approved and processed.', style: AppTextStyles.body.copyWith(color: AppColors.success)),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEvidenceCard(RefundEvidenceEntity evidence) {
    final isBuyer = evidence.submittedBy == 'buyer';
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isBuyer ? AppColors.infoSubtle : AppColors.warningSubtle,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isBuyer ? AppColors.info.withValues(alpha: 0.3) : AppColors.warning.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(isBuyer ? Icons.person : Icons.storefront, size: 16, color: isBuyer ? AppColors.info : AppColors.warning),
              const SizedBox(width: 6),
              Text(
                isBuyer ? 'Buyer Evidence' : 'Seller Evidence',
                style: AppTextStyles.bodySm.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isBuyer ? AppColors.info : AppColors.warning,
                ),
              ),
              const Spacer(),
              Text(
                DateFormat('MMM d, y').format(evidence.submittedAt),
                style: AppTextStyles.bodySm.copyWith(color: (Theme.of(context).brightness == Brightness.dark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight), fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(evidence.description, style: AppTextStyles.body),
          if (evidence.attachmentUrls.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text('${evidence.attachmentUrls.length} attachment(s)', style: AppTextStyles.bodySm.copyWith(color: (Theme.of(context).brightness == Brightness.dark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight))),
          ],
        ],
      ),
    );
  }

  // ──────────────────────────── Info & Actions ────────────────────────────

  Widget _buildTicketInfoCard(SupportTicketEntity ticket) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Ticket Information', style: AppTextStyles.h4),
          const SizedBox(height: AppSpacing.lg),
          _infoRow('Ticket ID', '#${ticket.id.replaceAll('ticket_', '')}'),
          const SizedBox(height: AppSpacing.sm),
          _infoRow('Category', ticket.category),
          const SizedBox(height: AppSpacing.sm),
          _infoRow('Priority', ticket.priority.toUpperCase()),
          const SizedBox(height: AppSpacing.sm),
          _infoRow('Created', DateFormat('MMM d, y · h:mm a').format(ticket.createdAt)),
          const SizedBox(height: AppSpacing.sm),
          _infoRow('Last Updated', DateFormat('MMM d, y · h:mm a').format(ticket.updatedAt)),
          const Divider(height: AppSpacing.xl),
          Text('Customer', style: AppTextStyles.h5),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              const CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.primarySubtle,
                child: Icon(Icons.person, color: AppColors.primary, size: 16),
              ),
              const SizedBox(width: AppSpacing.sm),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(ticket.userName, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
                  Text(ticket.userEmail, style: AppTextStyles.bodySm.copyWith(color: (Theme.of(context).brightness == Brightness.dark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight))),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionsCard(SupportTicketEntity ticket) {
    final isClosed = ticket.status == 'closed';
    final isResolved = ticket.status == 'resolved';
    final isEscalated = ticket.status == 'escalated';
    final isDone = isClosed || isResolved;

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Actions', style: AppTextStyles.h4.copyWith(color: AppColors.error)),
          const SizedBox(height: AppSpacing.lg),
          Obx(() => Column(
            children: [
              if (!isDone)
                SizedBox(
                  width: double.infinity,
                  child: AppButton(
                    label: 'Resolve Ticket',
                    icon: Icons.check_circle_outline,
                    isLoading: controller.isActing.value,
                    onPressed: () => AppConfirmationDialog.show(
                      context,
                      title: 'Resolve Ticket',
                      content: 'Mark this ticket as resolved?',
                      confirmText: 'Resolve',
                      onConfirm: () {
                        controller.resolveTicket();
                        Get.find<SupportTicketsController>().fetchTickets(isRefresh: true);
                      },
                    ),
                  ),
                ),
              if (!isDone && !isEscalated) ...[
                const SizedBox(height: AppSpacing.sm),
                SizedBox(
                  width: double.infinity,
                  child: AppButton(
                    label: 'Escalate Ticket',
                    icon: Icons.priority_high,
                    type: AppButtonType.outline,
                    isLoading: controller.isActing.value,
                    onPressed: () => AppConfirmationDialog.show(
                      context,
                      title: 'Escalate Ticket',
                      content: 'Escalate this ticket to a senior agent?',
                      confirmText: 'Escalate',
                      onConfirm: () {
                        controller.escalateTicket();
                        Get.find<SupportTicketsController>().fetchTickets(isRefresh: true);
                      },
                    ),
                  ),
                ),
              ],
              if (!isClosed) ...[
                const SizedBox(height: AppSpacing.sm),
                SizedBox(
                  width: double.infinity,
                  child: AppButton(
                    label: 'Close Ticket',
                    icon: Icons.close,
                    type: AppButtonType.outline,
                    isLoading: controller.isActing.value,
                    onPressed: () => AppConfirmationDialog.show(
                      context,
                      title: 'Close Ticket',
                      content: 'Close this support ticket? No further replies will be accepted.',
                      confirmText: 'Close',
                      onConfirm: () {
                        controller.closeTicket();
                        Get.find<SupportTicketsController>().fetchTickets(isRefresh: true);
                      },
                    ),
                  ),
                ),
              ],
              if (isDone) ...[
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.successSubtle,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, color: AppColors.success, size: 18),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        'Ticket is ${ticket.status}.',
                        style: AppTextStyles.body.copyWith(color: AppColors.success),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          )),
        ],
      ),
    );
  }

  Widget _buildAssignCard(SupportTicketEntity ticket) {
    final admins = [
      {'id': 'admin_1', 'name': 'John (Support)'},
      {'id': 'admin_2', 'name': 'Sarah (Level 2)'},
      {'id': 'admin_3', 'name': 'Mike (Refunds)'},
    ];

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.person_pin, color: AppColors.primary),
              const SizedBox(width: AppSpacing.sm),
              Text('Assign Ticket', style: AppTextStyles.h4),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          if (ticket.assignedAdminName != null) ...[
            Row(
              children: [
                const Icon(Icons.check_circle, color: AppColors.success, size: 16),
                const SizedBox(width: 6),
                Text(
                  'Assigned to: ${ticket.assignedAdminName}',
                  style: AppTextStyles.body.copyWith(color: AppColors.success),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
          ],
          DropdownButtonFormField<String>(
            value: ticket.assignedAdminId,
            decoration: const InputDecoration(
              labelText: 'Select Agent',
              border: OutlineInputBorder(),
              isDense: true,
            ),
            items: admins.map((a) => DropdownMenuItem(
              value: a['id'],
              child: Text(a['name']!),
            )).toList(),
            onChanged: (value) {
              if (value == null) return;
              final admin = admins.firstWhere((a) => a['id'] == value);
              controller.assignTicket(admin['id']!, admin['name']!);
            },
          ),
        ],
      ),
    );
  }

  // ──────────────────────────── Helpers ────────────────────────────

  Widget _buildStatusChip(String status) {
    AppStatusType type;
    switch (status) {
      case 'open': type = AppStatusType.info; break;
      case 'escalated': type = AppStatusType.error; break;
      case 'resolved': type = AppStatusType.success; break;
      default: type = AppStatusType.standard;
    }
    return AppStatusChip(label: status.toUpperCase(), type: type);
  }

  Widget _buildRefundStatusChip(String status) {
    AppStatusType type;
    switch (status) {
      case 'approved': type = AppStatusType.success; break;
      case 'rejected': type = AppStatusType.error; break;
      default: type = AppStatusType.warning;
    }
    return AppStatusChip(label: status.replaceAll('_', ' ').toUpperCase(), type: type);
  }

  Widget _infoRow(String label, String value) {
    return Row(
      children: [
        SizedBox(
          width: 120,
          child: Text(label, style: AppTextStyles.bodySm.copyWith(color: (Theme.of(context).brightness == Brightness.dark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight))),
        ),
        Expanded(child: Text(value, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w500))),
      ],
    );
  }
}

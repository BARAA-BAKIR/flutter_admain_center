import 'package:flutter/material.dart';
import 'package:flutter_admain_center/data/models/super_admin/permission_model.dart';
import 'package:flutter_admain_center/data/models/super_admin/role_model.dart';
import 'package:flutter_admain_center/domain/repositories/super_admin_repository.dart';
import 'package:flutter_admain_center/features/super_admin/bloc/roles_permissions_bloc/roles_permissions_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class RolesPermissionsScreen extends StatelessWidget {
  const RolesPermissionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RolesPermissionsBloc(
        repository: context.read<SuperAdminRepository>(),
      )..add(LoadRolesAndPermissions()),
      child: const RolesPermissionsView(),
    );
  }
}

class RolesPermissionsView extends StatelessWidget {
  const RolesPermissionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إدارة الأدوار والصلاحيات')),
      body: BlocConsumer<RolesPermissionsBloc, RolesState>(
        listener: (context, state) {
          if (state.status == RolesStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('فشل: ${state.errorMessage}'), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          if (state.status == RolesStatus.loading || state.status == RolesStatus.initial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == RolesStatus.submitting) {
            return const Center(child: CircularProgressIndicator(backgroundColor: Colors.orange));
          }
          return RefreshIndicator(
            onRefresh: () async => context.read<RolesPermissionsBloc>().add(LoadRolesAndPermissions()),
            child: ListView.builder(
              itemCount: state.roles.length,
              itemBuilder: (context, index) {
                final role = state.roles[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: ExpansionTile(
                    title: Text(role.name, style: GoogleFonts.tajawal(fontWeight: FontWeight.bold, fontSize: 18)),
                    children: [
                      _buildPermissionsMatrix(context, role, state.permissions),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildPermissionsMatrix(BuildContext context, Role role, Map<String, List<Permission>> allPermissions) {
    // Use a stateful widget to manage local selections before submitting
    return _PermissionsSelection(
      role: role,
      allPermissions: allPermissions,
      onSync: (selectedIds) {
        context.read<RolesPermissionsBloc>().add(SyncPermissions(roleId: role.id, permissionIds: selectedIds));
      },
    );
  }
}

// A stateful widget to handle the temporary selection of permissions
class _PermissionsSelection extends StatefulWidget {
  final Role role;
  final Map<String, List<Permission>> allPermissions;
  final Function(List<int>) onSync;

  const _PermissionsSelection({required this.role, required this.allPermissions, required this.onSync});

  @override
  State<_PermissionsSelection> createState() => _PermissionsSelectionState();
}

class _PermissionsSelectionState extends State<_PermissionsSelection> {
  late Set<int> _selectedPermissionIds;

  @override
  void initState() {
    super.initState();
    _selectedPermissionIds = widget.role.permissions.map((p) => p.id).toSet();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          ...widget.allPermissions.entries.map((entry) {
            String groupName = entry.key;
            List<Permission> permissionsInGroup = entry.value;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(groupName.toUpperCase(), style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                ),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: permissionsInGroup.map((permission) {
                    return ChoiceChip(
                      label: Text(permission.name.split(' ').sublist(1).join(' ')),
                      selected: _selectedPermissionIds.contains(permission.id),
                      onSelected: (isSelected) {
                        setState(() {
                          if (isSelected) {
                            _selectedPermissionIds.add(permission.id);
                          } else {
                            _selectedPermissionIds.remove(permission.id);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
                const Divider(height: 24),
              ],
            );
          }).toList(),
          Align(
            alignment: Alignment.centerLeft,
            child: ElevatedButton(
              onPressed: () => widget.onSync(_selectedPermissionIds.toList()),
              child: const Text('حفظ التغييرات'),
            ),
          )
        ],
      ),
    );
  }
}

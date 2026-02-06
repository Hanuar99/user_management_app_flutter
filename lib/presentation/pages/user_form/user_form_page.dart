import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_management_app/core/di/injection.dart';
import 'package:user_management_app/core/theme/app_spacing.dart';
import 'package:user_management_app/core/theme/app_styles.dart';
import 'package:user_management_app/domain/entities/user_entity.dart';
import 'package:user_management_app/presentation/blocs/user_form/user_form_bloc.dart';
import 'package:user_management_app/presentation/widgets/common/app_snackbar.dart';
import 'package:user_management_app/presentation/widgets/common/loading_widget.dart';

class UserFormPage extends StatelessWidget {
  final UserEntity? user;

  const UserFormPage({
    this.user,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<UserFormBloc>(param1: user),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            user == null ? 'Nuevo Usuario' : 'Editar Usuario',
          ),
        ),
        body: UserFormView(user: user),
      ),
    );
  }
}

class UserFormView extends StatefulWidget {
  final UserEntity? user;

  const UserFormView({this.user, super.key});

  @override
  State<UserFormView> createState() => _UserFormViewState();
}

class _UserFormViewState extends State<UserFormView> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();

    final user = widget.user;

    if (user != null) {
      _nameController.text = user.firstName;
      _lastNameController.text = user.lastName;
      _emailController.text = user.email;
      _phoneController.text = user.phone;
      _selectedDate = user.birthDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final userFormBloc = context.read<UserFormBloc>();
    return BlocListener<UserFormBloc, UserFormState>(
      listener: (context, state) {
        if (state.errorMessage != null) {
          AppSnackbar.showError(context, message: state.errorMessage!);
        }

        if (state.isSuccess) {
          final actionMessage = widget.user == null
              ? "Usuario creado exitosamente"
              : "Usuario actualizado exitosamente";

          AppSnackbar.showSuccess(context, message: actionMessage);

          Navigator.of(context).pop(true);
        }
      },
      child: BlocBuilder<UserFormBloc, UserFormState>(
        builder: (context, state) {
          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Información del usuario',
                    style: textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Completa los datos personales para registrar el usuario en el sistema.',
                    style: textTheme.bodySmall,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _buildSectionCard(
                    context,
                    title: 'Datos personales',
                    icon: Icons.person_outline,
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: "Nombre",
                          prefixIcon: const Icon(Icons.badge_outlined),
                          errorText: state.firstNameError,
                        ),
                        onChanged: (v) => context
                            .read<UserFormBloc>()
                            .add(FirstNameChanged(v)),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      TextFormField(
                        controller: _lastNameController,
                        decoration: InputDecoration(
                          labelText: "Apellido",
                          prefixIcon: const Icon(Icons.badge_outlined),
                          errorText: state.lastNameError,
                        ),
                        onChanged: (v) => context
                            .read<UserFormBloc>()
                            .add(LastNameChanged(v)),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _buildSectionCard(
                    context,
                    title: 'Contacto',
                    icon: Icons.contact_mail_outlined,
                    children: [
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: "Email",
                          prefixIcon: const Icon(Icons.email_outlined),
                          errorText: state.emailError,
                        ),
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (v) =>
                            context.read<UserFormBloc>().add(EmailChanged(v)),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      TextFormField(
                        controller: _phoneController,
                        decoration: InputDecoration(
                          labelText: "Teléfono",
                          prefixIcon: const Icon(Icons.phone_outlined),
                          errorText: state.phoneError,
                        ),
                        keyboardType: TextInputType.phone,
                        onChanged: (v) =>
                            context.read<UserFormBloc>().add(PhoneChanged(v)),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _buildSectionCard(
                    context,
                    title: 'Información adicional',
                    icon: Icons.cake_outlined,
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.calendar_today_outlined),
                        title: Text(
                          _selectedDate == null
                              ? "Seleccionar fecha de nacimiento"
                              : "Nacimiento: ${_selectedDate!.toLocal().toString().split(' ')[0]}",
                          style: textTheme.bodyMedium,
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            firstDate: DateTime(1920),
                            lastDate: DateTime.now(),
                            initialDate: DateTime(2000),
                          );

                          if (picked != null) {
                            setState(() {
                              _selectedDate = picked;
                            });

                            userFormBloc.add(BirthDateChanged(picked));
                          }
                        },
                      ),
                      if (state.birthDateError != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            state.birthDateError!,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: state.isSubmitting
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: LoadingWidget(),
                            )
                          : const Icon(Icons.save_outlined),
                      label: Text(
                        widget.user == null
                            ? "Guardar usuario"
                            : "Actualizar usuario",
                      ),
                      onPressed: state.isValid && !state.isSubmitting
                          ? () {
                              if (_formKey.currentState!.validate()) {
                                context.read<UserFormBloc>().add(
                                      SubmitUserForm(
                                        userId: widget.user?.id,
                                      ),
                                    );
                              }
                            }
                          : null,
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: AppStyles.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: AppSpacing.sm),
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          ...children,
        ],
      ),
    );
  }
}

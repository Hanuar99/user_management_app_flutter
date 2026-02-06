import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_management_app/core/di/injection.dart';
import 'package:user_management_app/core/theme/app_spacing.dart';
import 'package:user_management_app/core/theme/app_styles.dart';
import 'package:user_management_app/domain/entities/address_entity.dart';
import 'package:user_management_app/presentation/blocs/address_form/address_form_bloc.dart';

class AddressFormPage extends StatelessWidget {
  final String userId;
  final AddressEntity? address;

  const AddressFormPage({
    required this.userId,
    this.address,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AddressFormBloc>(param1: address),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            address == null ? 'Nueva Dirección' : 'Editar Dirección',
          ),
        ),
        body: _AddressFormView(
          userId: userId,
          address: address,
        ),
      ),
    );
  }
}

class _AddressFormView extends StatefulWidget {
  final String userId;
  final AddressEntity? address;

  const _AddressFormView({
    required this.userId,
    this.address,
  });

  @override
  State<_AddressFormView> createState() => __AddressFormViewState();
}

class __AddressFormViewState extends State<_AddressFormView> {
  final _formKey = GlobalKey<FormState>();

  final _streetController = TextEditingController();
  final _neighborhoodController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _postalCodeController = TextEditingController();

  String _selectedLabel = 'Casa';
  bool _isPrimary = false;

  @override
  void initState() {
    super.initState();

    final address = widget.address;

    if (address != null) {
      _streetController.text = address.street;
      _neighborhoodController.text = address.neighborhood;
      _cityController.text = address.city;
      _stateController.text = address.state;
      _postalCodeController.text = address.postalCode;
      _selectedLabel = address.label;
      _isPrimary = address.isPrimary;
    }

    context.read<AddressFormBloc>().add(LabelChanged(_selectedLabel));
  }

  @override
  void dispose() {
    _streetController.dispose();
    _neighborhoodController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _postalCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return BlocConsumer<AddressFormBloc, AddressFormState>(
      listener: (context, state) {
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage!)),
          );
        }

        if (state.isSuccess) {
          Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        return Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Información de la dirección',
                  style: textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Completa los datos para registrar la dirección del usuario.',
                  style: textTheme.bodySmall,
                ),
                const SizedBox(height: AppSpacing.lg),
                _buildSectionCard(
                  context,
                  title: 'Ubicación',
                  icon: Icons.location_on_outlined,
                  children: [
                    TextFormField(
                      controller: _streetController,
                      decoration: InputDecoration(
                        labelText: 'Calle y número',
                        prefixIcon: Icon(Icons.home_outlined),
                        errorText: state.streetError,
                      ),
                      onChanged: (v) =>
                          context.read<AddressFormBloc>().add(StreetChanged(v)),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextFormField(
                      controller: _neighborhoodController,
                      decoration: InputDecoration(
                        labelText: 'Colonia / Barrio',
                        prefixIcon: Icon(Icons.map_outlined),
                        errorText: state.neighborhoodError,
                      ),
                      onChanged: (v) => context
                          .read<AddressFormBloc>()
                          .add(NeighborhoodChanged(v)),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                _buildSectionCard(
                  context,
                  title: 'Datos geográficos',
                  icon: Icons.public,
                  children: [
                    TextFormField(
                      controller: _cityController,
                      decoration: InputDecoration(
                        labelText: 'Ciudad',
                        prefixIcon: Icon(Icons.location_city),
                        errorText: state.cityError,
                      ),
                      onChanged: (v) =>
                          context.read<AddressFormBloc>().add(CityChanged(v)),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextFormField(
                      controller: _stateController,
                      decoration: InputDecoration(
                        labelText: 'Estado / Provincia',
                        prefixIcon: Icon(Icons.flag_outlined),
                        errorText: state.stateError,
                      ),
                      onChanged: (v) =>
                          context.read<AddressFormBloc>().add(StateChanged(v)),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextFormField(
                      controller: _postalCodeController,
                      decoration: InputDecoration(
                          labelText: 'Código Postal',
                          prefixIcon: Icon(Icons.local_post_office_outlined),
                          errorText: state.postalCodeError),
                      keyboardType: TextInputType.number,
                      onChanged: (v) => context
                          .read<AddressFormBloc>()
                          .add(PostalCodeChanged(v)),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                _buildSectionCard(
                  context,
                  title: 'Configuración',
                  icon: Icons.settings_outlined,
                  children: [
                    DropdownButtonFormField<String>(
                      value: _selectedLabel,
                      decoration: const InputDecoration(
                        labelText: 'Etiqueta',
                        prefixIcon: Icon(Icons.label_outline),
                      ),
                      style: textTheme.bodyLarge,
                      items: const [
                        DropdownMenuItem(
                          value: 'Casa',
                          child: Text('Casa'),
                        ),
                        DropdownMenuItem(
                          value: 'Trabajo',
                          child: Text('Trabajo'),
                        ),
                        DropdownMenuItem(
                          value: 'Otro',
                          child: Text('Otro'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _selectedLabel = value;
                          });

                          context
                              .read<AddressFormBloc>()
                              .add(LabelChanged(value));
                        }
                      },
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        'Dirección principal',
                        style: textTheme.titleSmall?.copyWith(fontSize: 16),
                      ),
                      subtitle: Text(
                        'Se usará como dirección predeterminada del usuario',
                        style: textTheme.bodySmall,
                      ),
                      value: _isPrimary,
                      onChanged: (value) {
                        setState(() {
                          _isPrimary = value;
                        });

                        context
                            .read<AddressFormBloc>()
                            .add(PrimaryChanged(value));
                      },
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
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.save),
                    label: Text(
                      widget.address == null
                          ? 'Guardar dirección'
                          : 'Actualizar dirección',
                    ),
                    onPressed: state.isValid && !state.isSubmitting
                        ? () {
                            if (_formKey.currentState!.validate()) {
                              context.read<AddressFormBloc>().add(
                                    SubmitAddressForm(
                                      userId: widget.userId,
                                      addressId: widget.address?.id,
                                    ),
                                  );
                            }
                          }
                        : null,
                  ),
                ),
              ],
            ),
          ),
        );
      },
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

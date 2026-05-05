import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget
{
  const ProfileScreen ({super.key});

  @override
  Widget build(BuildContext context)
  {
    final colors = Theme.of(context).colorScheme;

    return Scaffold
    (
      appBar: AppBar
      (
        title: const Text
        (
          'Perfil',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: colors.primary,
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView
      (
        padding: const EdgeInsets.all(24),
        child: Column
        (
          crossAxisAlignment: CrossAxisAlignment.center,
          children: 
          [
            const SizedBox(height: 24),

            //foto del perfil
            const CircleAvatar
            (
              radius: 56,
              backgroundImage: AssetImage('assets/images/profile.png'),
            ),
            const SizedBox(height: 16),

            //nombre del usuario
            const Text
            (
              'Capi',
              style: TextStyle
              (
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),

            //correo del perfil
            Row
            (
              mainAxisAlignment: MainAxisAlignment.center,
              children: 
              [
                Icon(Icons.email_outlined, size: 15, color: Colors.grey[500]),
                const SizedBox(width: 6),
                Text
                (
                  'capi@example.com',
                  style: TextStyle
                  (
                    fontSize: 13,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            //estadisticas
            Align
            (
              alignment: Alignment.centerLeft,
              child: Row
              (
                children: 
                [
                  Container
                  (
                    width: 4,
                    height: 18,
                    decoration: BoxDecoration
                    (
                      color: colors.primary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 8),

                  const Text
                  (
                    'Estadísticas',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            //tarjetas de estadisticas
            Row
            (
              children: 
              [
                Expanded
                (
                  child: _StatCard
                  (
                    icon: Icons.check_circle_rounded,
                    iconColor: Colors.green,
                    label: 'Completadas',
                    value: '24',
                  ),
                ),
              
                const SizedBox(width: 12),

                Expanded
                (
                  child: _StatCard
                  (
                    icon: Icons.pending_actions_rounded,
                    iconColor: const Color(0xFF5C6BC0),
                    label: 'Pendientes',
                    value: '5',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            Row
            (
              children: 
              [
                Expanded
                (
                  child: _StatCard
                  (
                    icon: Icons.timer_off_rounded,
                    iconColor: colors.primary,
                    label: 'Vencidas',
                    value: '3',
                  ),
                ),
                const SizedBox(width: 12),

                Expanded
                (
                  child: _StatCard
                  (
                    icon: Icons.bar_chart_rounded,
                    iconColor: const Color(0xFF26A69A),
                    label: 'Total',
                    value: '32',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            //informacio de la cuenta
            Align
            (
              alignment: Alignment.centerLeft,
              child: Row
              (
                children: 
                [
                  Container
                  (
                    width: 4,
                    height: 18,
                    decoration: BoxDecoration
                    (
                      color: colors.primary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 8),

                  const Text
                  (
                    'Cuenta',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            Container
            (
              width: double.infinity,
              decoration: BoxDecoration 
              (
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),

              child: Column
              (
                children: 
                [
                  _InfoRow
                  (
                    icon: Icons.person_outline,
                    iconColor: const Color(0xFF5C6BC0),
                    label: 'Nombre',
                    value: 'Capi',
                  ),
                  Divider(height: 1, color: Colors.grey.shade200),

                  _InfoRow
                  (
                    icon: Icons.email_outlined,
                    iconColor: const Color(0xFF26A69A),
                    label: 'Correo',
                    value: 'capi@example.com',
                  ),
                  Divider(height: 1, color: Colors.grey.shade200),

                  _InfoRow
                  (
                    icon: Icons.calendar_today_outlined,
                    iconColor: const Color(0xFF546E7A),
                    label: 'Miembro desde',
                    value: 'Mayo 2026',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

//estructura de las tarjetas de informacion
class _StatCard extends StatelessWidget 
{
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  const _StatCard
  ({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) 
  {
    return Container
    (
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration
      (
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),

      child: Column
      (
        children: 
        [
          Icon(icon, color: iconColor, size: 28),
          const SizedBox(height: 8),
          Text
          (
            value,
            style: const TextStyle
            (
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),

          Text
          (
            label,
            style: TextStyle
            (
              fontSize: 12,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}

//estructura de las filas de informacion
class _InfoRow extends StatelessWidget 
{
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  const _InfoRow
  ({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) 
  {
    return Padding
    (
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row
      (
        children: 
        [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(width: 12),
          Text
          (
            label,
            style: TextStyle
            (
              fontSize: 13,
              color: Colors.grey[500],
            ),
          ),
          const Spacer(),

          Text
          (
            value,
            style: const TextStyle
            (
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
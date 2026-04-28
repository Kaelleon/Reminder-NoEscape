import 'dart:math' as math;
import 'package:flutter/material.dart';

@immutable
class ExpandableFab extends StatefulWidget 
{
  const ExpandableFab
  ({
    super.key, 
    this.initialOpen, 
    required this.distance, 
    required this.children,
  });

  final bool? initialOpen;
  final double distance;
  final List<Widget> children;

  @override
  State<ExpandableFab> createState() => _ExpandableFabState();
}

class _ExpandableFabState extends State<ExpandableFab>
  with SingleTickerProviderStateMixin
{
  late final AnimationController _controller;
  late final Animation<double> _expandAnimation;
  bool _open = false;

  @override
  void initState()
  {
    super.initState();
    _open = widget.initialOpen ?? false;

    _controller = AnimationController
    (
      value: _open ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );

    _expandAnimation = CurvedAnimation
    (
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose()
  {
    _controller.dispose();
    super.dispose();
  }

  void _toggle()
  {
    setState(() 
    {
      _open = !_open; 

      if (_open)
      {
        _controller.forward();
      }
      else
      {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context)
  {
    return SizedBox.expand
    (
      child: Stack
      (
        alignment: Alignment.bottomRight,
        clipBehavior: Clip.none,
        children: 
        [
          _buildExpandingButtons(), 
          _buildTapToOpenFab(),
          if (_open) _buildTapToCloseFab(),
        ],
      ),
    );
  }

  //botones hijos
  Widget _buildExpandingButtons()
  {
    final children = <Widget>[];
    final count = widget.children.length;

    if (count == 0) return const SizedBox();

    final step = count == 1 ? 0 : 90.0 / (count -1);

    for (int i =0; i < count; i++)
    {
      final double angle = step * i.toDouble();

      children.add(_ExpandingActionButton
      (
        directionInDegrees: angle,
        maxDistance: widget.distance,
        progress: _expandAnimation,
        child: widget.children[i],
      ),
      );
    }

    return Stack(children: children);
  }

  //boton principal
  Widget _buildTapToOpenFab() 
  {
    return IgnorePointer
    (
      ignoring: _open,
      child: AnimatedOpacity
      (
        opacity: _open ? 0.0 : 1.0, 
        duration: const Duration(milliseconds: 250),
        child: FloatingActionButton
        (
          heroTag: "expandable_fab_open",
          onPressed: _toggle,
          child: const Icon(Icons.menu),
        ),
      ),
    );
  }

  //boton cerrar
  Widget _buildTapToCloseFab()
  {
    return FloatingActionButton
    (
      heroTag: "expandable_fab_close",
      onPressed: _toggle,
      mini: true,
      child: const Icon(Icons.close),
    );
  }
}

//boton individual
class _ExpandingActionButton extends StatelessWidget 
{
  const _ExpandingActionButton
  ({
    required this.directionInDegrees,
    required this.maxDistance,
    required this.progress,
    required this.child,
  });

  final double directionInDegrees;
  final double maxDistance;
  final Animation<double> progress;
  final Widget child;

  @override
  Widget build(BuildContext context) 
  {
    return AnimatedBuilder
    (
      animation: progress,
      builder: (context, child) 
      {
        final offset = Offset.fromDirection
        (
          directionInDegrees * (math.pi / 180.0),
          progress.value * maxDistance,
        );

        return Positioned
        (
          right: 4 + offset.dx,
          bottom: 4 + offset.dy,
          child: child!,
        );
      },
      child: child,
    );
  }
}
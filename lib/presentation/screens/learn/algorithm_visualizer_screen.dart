import 'dart:math';
import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

// ─── Types ────────────────────────────────────────────────────────────────────

enum AlgoType { bubbleSort, selectionSort, mergeSort, binarySearch, bfs, dfs }

class _Algo {
  final String name, emoji, time, space, desc;
  final Color color;
  const _Algo(this.name, this.emoji, this.time, this.space, this.desc, this.color);
}

const _algoDefs = <AlgoType, _Algo>{
  AlgoType.bubbleSort:    _Algo('Bubble Sort',    '🫧', 'O(n²)',      'O(1)', 'Repeatedly swaps adjacent elements in the wrong order.',         AppColors.neonCyan),
  AlgoType.selectionSort: _Algo('Selection Sort', '🎯', 'O(n²)',      'O(1)', 'Finds the minimum element and places it at the front.',          AppColors.neonYellow),
  AlgoType.mergeSort:     _Algo('Merge Sort',     '🔀', 'O(n log n)', 'O(n)', 'Divides, sorts each half recursively, then merges.',             AppColors.neonGreen),
  AlgoType.binarySearch:  _Algo('Binary Search',  '🔍', 'O(log n)',   'O(1)', 'Halves the search space each step on a sorted array.',           AppColors.neonPurple),
  AlgoType.bfs:           _Algo('BFS',            '🌊', 'O(V+E)',     'O(V)', 'Explores nodes level-by-level using a queue.',                   AppColors.neonBlue),
  AlgoType.dfs:           _Algo('DFS',            '🕳️', 'O(V+E)',     'O(V)', 'Explores as deep as possible before backtracking.',              AppColors.neonOrange),
};

// ─── Step models ──────────────────────────────────────────────────────────────

class _SortStep {
  final List<int> arr;
  final Set<int> hi, sorted, pivot;
  final String msg;
  const _SortStep(this.arr, this.msg, {this.hi=const{}, this.sorted=const{}, this.pivot=const{}});
}

class _GraphStep {
  final Set<int> visited, current, queued;
  final String msg;
  const _GraphStep(this.visited, this.current, this.queued, this.msg);
}

// ─── Step generators ─────────────────────────────────────────────────────────

List<_SortStep> _bubble(List<int> a) {
  final s = <_SortStep>[], arr = List<int>.from(a), done = <int>{};
  for (int i = 0; i < arr.length - 1; i++) {
    for (int j = 0; j < arr.length - i - 1; j++) {
      s.add(_SortStep(List.from(arr), 'Compare ${arr[j]} and ${arr[j+1]}', hi: {j, j+1}, sorted: Set.from(done)));
      if (arr[j] > arr[j+1]) { final t = arr[j]; arr[j] = arr[j+1]; arr[j+1] = t; s.add(_SortStep(List.from(arr), 'Swap!', hi: {j, j+1}, sorted: Set.from(done))); }
    }
    done.add(arr.length - 1 - i);
  }
  done.add(0);
  s.add(_SortStep(List.from(arr), '✅ Sorted!', sorted: {for(int i=0;i<arr.length;i++)i}));
  return s;
}

List<_SortStep> _selection(List<int> a) {
  final s = <_SortStep>[], arr = List<int>.from(a), done = <int>{};
  for (int i = 0; i < arr.length - 1; i++) {
    int m = i;
    for (int j = i+1; j < arr.length; j++) {
      s.add(_SortStep(List.from(arr), 'Is ${arr[j]} < min ${arr[m]}?', hi: {j}, pivot: {m}, sorted: Set.from(done)));
      if (arr[j] < arr[m]) m = j;
    }
    if (m != i) { final t = arr[i]; arr[i] = arr[m]; arr[m] = t; }
    done.add(i);
    s.add(_SortStep(List.from(arr), 'Placed ${arr[i]} at index $i', sorted: Set.from(done)));
  }
  done.add(arr.length-1);
  s.add(_SortStep(List.from(arr), '✅ Sorted!', sorted: {for(int i=0;i<arr.length;i++)i}));
  return s;
}

List<_SortStep> _mergeSort(List<int> a) {
  final s = <_SortStep>[], arr = List<int>.from(a);
  void merge(int lo, int mid, int hi) {
    final L = arr.sublist(lo, mid+1), R = arr.sublist(mid+1, hi+1);
    int i=0, j=0, k=lo;
    while(i<L.length && j<R.length) {
      s.add(_SortStep(List.from(arr), 'Compare ${L[i]} vs ${R[j]}', hi: {lo+i, mid+1+j}));
      arr[k++] = L[i] <= R[j] ? L[i++] : R[j++];
    }
    while(i<L.length) arr[k++] = L[i++];
    while(j<R.length) arr[k++] = R[j++];
    s.add(_SortStep(List.from(arr), 'Merged [$lo..$hi]', sorted: {for(int x=lo;x<=hi;x++)x}));
  }
  void sort(int lo, int hi) {
    if (lo >= hi) return;
    int mid = (lo+hi)~/2;
    s.add(_SortStep(List.from(arr), 'Split [$lo..$hi]', hi: {lo,hi}));
    sort(lo, mid); sort(mid+1, hi); merge(lo, mid, hi);
  }
  sort(0, arr.length-1);
  s.add(_SortStep(List.from(arr), '✅ Sorted!', sorted: {for(int i=0;i<arr.length;i++)i}));
  return s;
}

List<_SortStep> _binarySearch(List<int> a, int target) {
  final arr = List<int>.from(a)..sort();
  final s = <_SortStep>[];
  s.add(_SortStep(arr, 'Array sorted. Searching for $target'));
  int lo = 0, hi = arr.length - 1;
  while (lo <= hi) {
    int mid = (lo+hi)~/2;
    s.add(_SortStep(arr, 'lo=$lo hi=$hi mid=$mid → arr[$mid]=${arr[mid]}', hi: {lo,hi}, pivot: {mid}));
    if (arr[mid] == target) { s.add(_SortStep(arr, '✅ Found $target at index $mid!', sorted: {mid})); return s; }
    else if (arr[mid] < target) { lo = mid+1; s.add(_SortStep(arr, '${arr[mid]} < $target → search right', hi: {mid})); }
    else { hi = mid-1; s.add(_SortStep(arr, '${arr[mid]} > $target → search left', hi: {mid})); }
  }
  s.add(_SortStep(arr, '❌ $target not found'));
  return s;
}

const _gEdges = {0:[1,2], 1:[0,3,4], 2:[0,5], 3:[1], 4:[1,5], 5:[2,4]};

List<_GraphStep> _bfsSteps() {
  final s = <_GraphStep>[], visited = <int>{0};
  final q = [0];
  s.add(_GraphStep({0}, {0}, {}, 'Start at node 0'));
  while (q.isNotEmpty) {
    final n = q.removeAt(0);
    s.add(_GraphStep(Set.from(visited), {n}, Set.from(q), 'Visit node $n'));
    for (final nb in _gEdges[n]!) {
      if (!visited.contains(nb)) { visited.add(nb); q.add(nb); s.add(_GraphStep(Set.from(visited), {n}, Set.from(q), 'Queue node $nb')); }
    }
  }
  s.add(_GraphStep(Set.from(visited), {}, {}, '✅ BFS complete!'));
  return s;
}

List<_GraphStep> _dfsSteps() {
  final s = <_GraphStep>[], visited = <int>{};
  void dfs(int n) {
    visited.add(n);
    s.add(_GraphStep(Set.from(visited), {n}, {}, 'Visit node $n'));
    for (final nb in _gEdges[n]!) {
      if (!visited.contains(nb)) { s.add(_GraphStep(Set.from(visited), {n}, {nb}, 'Go deeper → $nb')); dfs(nb); s.add(_GraphStep(Set.from(visited), {n}, {}, 'Back to node $n')); }
    }
  }
  dfs(0);
  s.add(_GraphStep(Set.from(visited), {}, {}, '✅ DFS complete!'));
  return s;
}

// ─── Screen ───────────────────────────────────────────────────────────────────

class AlgorithmVisualizerScreen extends StatefulWidget {
  const AlgorithmVisualizerScreen({super.key});
  @override State<AlgorithmVisualizerScreen> createState() => _State();
}

class _State extends State<AlgorithmVisualizerScreen> {
  AlgoType _type = AlgoType.bubbleSort;
  List<_SortStep> _ss = [];
  List<_GraphStep> _gs = [];
  int _idx = 0;
  bool _playing = false;
  double _speed = 1.0;
  late List<int> _arr;
  late int _target;

  @override void initState() { super.initState(); _reset(); }

  void _reset() {
    _playing = false; _idx = 0;
    _arr = List.generate(12, (_) => Random().nextInt(80)+15);
    _target = _arr[Random().nextInt(_arr.length)];
    _gen();
  }

  void _gen() {
    switch(_type) {
      case AlgoType.bubbleSort:    _ss=_bubble(_arr);             _gs=[];
      case AlgoType.selectionSort: _ss=_selection(_arr);          _gs=[];
      case AlgoType.mergeSort:     _ss=_mergeSort(_arr);          _gs=[];
      case AlgoType.binarySearch:  _ss=_binarySearch(_arr,_target);_gs=[];
      case AlgoType.bfs:           _gs=_bfsSteps();               _ss=[];
      case AlgoType.dfs:           _gs=_dfsSteps();               _ss=[];
    }
  }

  bool get _isGraph => _type==AlgoType.bfs || _type==AlgoType.dfs;
  int get _total => _isGraph ? _gs.length : _ss.length;
  String get _msg => _isGraph
    ? (_gs.isEmpty ? '' : _gs[_idx.clamp(0,_gs.length-1)].msg)
    : (_ss.isEmpty ? '' : _ss[_idx.clamp(0,_ss.length-1)].msg);

  void _play() { setState(()=>_playing=true); _tick(); }
  void _tick() {
    if (!_playing || !mounted) return;
    if (_idx >= _total-1) { setState(()=>_playing=false); return; }
    setState(()=>_idx++);
    Future.delayed(Duration(milliseconds:(700/_speed).round()), _tick);
  }

  @override
  Widget build(BuildContext context) {
    final def = _algoDefs[_type]!;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.neonCyan), onPressed: ()=>Navigator.pop(context)),
        title: const Text('ALGORITHM VISUALIZER'),
        actions: [IconButton(icon: Icon(Icons.refresh, color: context.cqTextMuted), onPressed: ()=>setState(_reset))],
      ),
      body: Column(children: [
        // Algo selector
        SizedBox(height:48, child: ListView(scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal:12, vertical:8),
          children: _algoDefs.entries.map((e) {
            final sel = e.key==_type;
            return GestureDetector(onTap: ()=>setState((){_type=e.key; _reset();}),
              child: AnimatedContainer(duration: const Duration(milliseconds:200),
                margin: const EdgeInsets.only(right:8), padding: EdgeInsets.symmetric(horizontal:12),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),
                  color: sel ? e.value.color.withOpacity(0.18) : context.cqCard,
                  border: Border.all(color: sel ? e.value.color : context.cqSurface, width: sel?1.5:1)),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Text(e.value.emoji, style: const TextStyle(fontSize:14)),
                  SizedBox(width:6),
                  Text(e.value.name, style: TextStyle(fontFamily:'Rajdhani', fontSize:13, fontWeight:FontWeight.bold,
                    color: sel ? e.value.color : context.cqTextMuted)),
                ]),
              ),
            );
          }).toList())),
        // Info
        Container(padding: EdgeInsets.symmetric(horizontal:16, vertical:8), color: context.cqBgSecondary,
          child: Row(children: [
            _Chip('Time', def.time, def.color), SizedBox(width:8),
            _Chip('Space', def.space, context.cqTextMuted), const SizedBox(width:10),
            Expanded(child: Text(def.desc, maxLines:2, overflow:TextOverflow.ellipsis,
              style: TextStyle(fontFamily:'Rajdhani', fontSize:11, color:context.cqTextMuted))),
          ])),
        // Viz
        Expanded(child: _isGraph ? _buildGraph(def) : _buildBars(def)),
        // Explanation
        AnimatedSwitcher(duration: const Duration(milliseconds:150),
          child: Container(key: ValueKey(_msg), width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal:20, vertical:10),
            color: context.cqCardSecondary,
            child: Text(_msg, textAlign: TextAlign.center,
              style: TextStyle(fontFamily:'Rajdhani', fontSize:14, fontWeight:FontWeight.w600, color:context.cqTextPrimary)))),
        // Controls
        _buildControls(def),
      ]),
    );
  }

  Widget _buildBars(_Algo def) {
    if (_ss.isEmpty) return const SizedBox();
    final step = _ss[_idx.clamp(0, _ss.length-1)];
    final maxV = step.arr.reduce(max).toDouble();
    return Padding(padding: EdgeInsets.fromLTRB(12,12,12,4), child: Column(children: [
      LinearProgressIndicator(value: _total>1?_idx/(_total-1):0, backgroundColor:context.cqSurface,
        valueColor: AlwaysStoppedAnimation(def.color), minHeight:3, borderRadius:BorderRadius.circular(2)),
      const SizedBox(height:4),
      Text('Step ${_idx+1} / $_total', style: TextStyle(fontFamily:'Share Tech Mono', fontSize:10, color:context.cqTextMuted)),
      const SizedBox(height:10),
      Expanded(child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: step.arr.asMap().entries.map((e) {
        final i=e.key, v=e.value;
        final Color c = step.sorted.contains(i) ? AppColors.neonGreen
          : step.pivot.contains(i) ? AppColors.neonYellow
          : step.hi.contains(i) ? def.color : def.color.withOpacity(0.25);
        return Expanded(child: AnimatedContainer(duration: const Duration(milliseconds:150),
          margin: const EdgeInsets.symmetric(horizontal:1),
          height: (v/maxV)*170,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(3), color: c,
            boxShadow: step.hi.contains(i)?[BoxShadow(color:c.withOpacity(0.5), blurRadius:8)]:null)));
      }).toList())),
      SizedBox(height:2),
      Row(children: step.arr.asMap().entries.map((e)=>Expanded(child: Text(e.value.toString(),
        textAlign:TextAlign.center, style: TextStyle(fontFamily:'Share Tech Mono', fontSize:8,
          color: step.hi.contains(e.key) ? def.color : context.cqTextMuted)))).toList()),
    ]));
  }

  Widget _buildGraph(_Algo def) {
    if (_gs.isEmpty) return const SizedBox();
    final step = _gs[_idx.clamp(0, _gs.length-1)];
    const pos = {0:Offset(.5,.1), 1:Offset(.2,.4), 2:Offset(.8,.4), 3:Offset(.1,.75), 4:Offset(.5,.75), 5:Offset(.9,.75)};
    return Padding(padding: EdgeInsets.all(12), child: Column(children: [
      LinearProgressIndicator(value: _total>1?_idx/(_total-1):0, backgroundColor:context.cqSurface,
        valueColor: AlwaysStoppedAnimation(def.color), minHeight:3, borderRadius:BorderRadius.circular(2)),
      const SizedBox(height:4),
      Text('Step ${_idx+1} / $_total', style: TextStyle(fontFamily:'Share Tech Mono', fontSize:10, color:context.cqTextMuted)),
      Expanded(child: LayoutBuilder(builder:(ctx,box)=>Stack(children:[
        CustomPaint(size:Size(box.maxWidth, box.maxHeight), painter:_EdgePainter(pos, context.cqSurface)),
        ...pos.keys.map((n){
          final p=pos[n]!;
          final Color c = step.current.contains(n) ? def.color
            : step.visited.contains(n) ? def.color.withOpacity(0.45)
            : step.queued.contains(n) ? AppColors.neonYellow : context.cqCard;
          return Positioned(left:p.dx*box.maxWidth-24, top:p.dy*box.maxHeight-24,
            child: AnimatedContainer(duration: const Duration(milliseconds:300),
              width:48, height:48,
              decoration: BoxDecoration(shape:BoxShape.circle, color:c,
                border: Border.all(color: step.current.contains(n)?Colors.white:def.color.withOpacity(0.4), width: step.current.contains(n)?2:1),
                boxShadow: step.current.contains(n)?[BoxShadow(color:def.color.withOpacity(0.5),blurRadius:14)]:null),
              child: Center(child: Text('$n', style: TextStyle(fontFamily:'Orbitron', fontSize:16, fontWeight:FontWeight.bold,
                color: step.current.contains(n)||step.visited.contains(n)?Colors.white:context.cqTextMuted)))));
        }),
      ]))),
      Row(mainAxisAlignment:MainAxisAlignment.center, children:[
        _Dot(def.color,'Current'), const SizedBox(width:14),
        _Dot(def.color.withOpacity(0.4),'Visited'), const SizedBox(width:14),
        _Dot(AppColors.neonYellow,'Queued'), SizedBox(width:14),
        _Dot(context.cqCard,'Unvisited'),
      ]),
    ]));
  }

  Widget _buildControls(_Algo def) {
    return Container(padding: EdgeInsets.fromLTRB(16,8,16,20), color: context.cqBgSecondary,
      child: Column(children:[
        Row(children:[
          Text('🐢', style:TextStyle(fontSize:16)),
          Expanded(child: Slider(value:_speed, min:0.25, max:3.0, divisions:11,
            activeColor:AppColors.neonCyan, inactiveColor:context.cqSurface,
            onChanged:(v)=>setState(()=>_speed=v))),
          const Text('🐇', style:TextStyle(fontSize:16)),
          const SizedBox(width:6),
          Text('${_speed.toStringAsFixed(1)}×', style: TextStyle(fontFamily:'Share Tech Mono', fontSize:10, color:context.cqTextMuted)),
        ]),
        Row(mainAxisAlignment:MainAxisAlignment.center, children:[
          _CBtn(Icons.skip_previous, ()=>setState((){_playing=false;_idx=0;})),
          const SizedBox(width:8),
          _CBtn(Icons.navigate_before, _playing?null:()=>setState((){if(_idx>0)_idx--;})),
          const SizedBox(width:8),
          GestureDetector(onTap:_playing?()=>setState(()=>_playing=false):_play,
            child: Container(width:54, height:54,
              decoration: BoxDecoration(shape:BoxShape.circle, gradient:AppColors.cyberpunkGradient),
              child: Icon(_playing?Icons.pause:Icons.play_arrow, color:Colors.white, size:28))),
          const SizedBox(width:8),
          _CBtn(Icons.navigate_next, _playing?null:()=>setState((){if(_idx<_total-1)_idx++;})),
          const SizedBox(width:8),
          _CBtn(Icons.skip_next, ()=>setState((){_playing=false;_idx=_total-1;})),
        ]),
      ]));
  }
}

class _EdgePainter extends CustomPainter {
  final Map<int,Offset> pos;
  final Color surfaceColor;
  const _EdgePainter(this.pos, this.surfaceColor);
  @override void paint(Canvas c, Size s) {
    final p = Paint()..color=surfaceColor..strokeWidth=1.5..style=PaintingStyle.stroke;
    const edges = [[0,1],[0,2],[1,3],[1,4],[2,5],[4,5]];
    for (final e in edges) {
      final a=pos[e[0]]!, b=pos[e[1]]!;
      c.drawLine(Offset(a.dx*s.width,a.dy*s.height), Offset(b.dx*s.width,b.dy*s.height), p);
    }
  }
  @override bool shouldRepaint(_)=>false;
}

class _Chip extends StatelessWidget {
  final String l,v; final Color c;
  const _Chip(this.l,this.v,this.c);
  @override Widget build(BuildContext ctx)=>Container(
    padding: const EdgeInsets.symmetric(horizontal:8,vertical:4),
    decoration: BoxDecoration(borderRadius:BorderRadius.circular(6), color:c.withOpacity(0.1), border:Border.all(color:c.withOpacity(0.3))),
    child: Column(children:[
      Text(l, style:TextStyle(fontFamily:'Rajdhani', fontSize:9, color:ctx.cqTextMuted)),
      Text(v, style:TextStyle(fontFamily:'Share Tech Mono', fontSize:11, fontWeight:FontWeight.bold, color:c)),
    ]));
}

class _Dot extends StatelessWidget {
  final Color c; final String l;
  const _Dot(this.c,this.l);
  @override Widget build(BuildContext ctx)=>Row(mainAxisSize:MainAxisSize.min, children:[
    Container(width:10,height:10,decoration:BoxDecoration(shape:BoxShape.circle,color:c)),
    const SizedBox(width:4),
    Text(l, style:TextStyle(fontFamily:'Rajdhani',fontSize:11,color:ctx.cqTextMuted)),
  ]);
}

class _CBtn extends StatelessWidget {
  final IconData icon; final VoidCallback? onTap;
  const _CBtn(this.icon, this.onTap);
  @override Widget build(BuildContext ctx)=>GestureDetector(onTap:onTap,
    child: Container(width:44,height:44,
      decoration: BoxDecoration(shape:BoxShape.circle, color:onTap==null?ctx.cqCard.withOpacity(0.4):ctx.cqCard, border:Border.all(color:ctx.cqSurface)),
      child: Icon(icon, color:onTap==null?ctx.cqTextMuted.withOpacity(0.3):ctx.cqTextMuted, size:20)));
}

/// Flutter package for Japanese horizontal text (yokogaki) layout
/// with advanced typography features.
library;

// Widgets
export 'src/widgets/horizontal_text.dart';
export 'src/widgets/horizontal_rich_text.dart';
export 'src/widgets/selectable_horizontal_text.dart';
export 'src/widgets/selection_area_horizontal_text.dart';

// Models
export 'src/models/horizontal_text_style.dart';
export 'src/models/horizontal_text_span.dart';
export 'src/models/ruby_text.dart';
export 'src/models/kenten.dart';
export 'src/models/warichu.dart';
export 'src/models/text_decoration.dart';
export 'src/models/gaiji.dart';

// Utils (for advanced usage)
export 'src/utils/decoration_renderer.dart';
export 'src/utils/gaiji_renderer.dart';

// Re-export kinsoku package for convenience
export 'package:kinsoku/kinsoku.dart';

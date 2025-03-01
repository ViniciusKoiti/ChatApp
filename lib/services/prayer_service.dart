import 'dart:math';

class Prayer {
  final String title;
  final String text;

  Prayer({required this.title, required this.text});
}

class PrayerService {
  static final List<Prayer> _prayers = [
    Prayer(
      title: 'Oração pela Paz',
      text: 'Senhor, faz de mim um instrumento da tua paz. Onde houver ódio, que eu leve o amor. Onde houver ofensa, que eu leve o perdão. Onde houver discórdia, que eu leve a união. Onde houver dúvida, que eu leve a fé. Onde houver erro, que eu leve a verdade. Onde houver desespero, que eu leve a esperança. Onde houver tristeza, que eu leve a alegria. Onde houver trevas, que eu leve a luz. Ó Mestre, faz que eu procure mais consolar que ser consolado, compreender que ser compreendido, amar que ser amado. Pois é dando que se recebe, é perdoando que se é perdoado, e é morrendo que se vive para a vida eterna.',
    ),
    Prayer(
      title: 'Oração da Serenidade',
      text: 'Deus, conceda-me a serenidade para aceitar as coisas que não posso mudar, coragem para mudar as coisas que posso, e sabedoria para discernir a diferença. Vivendo um dia de cada vez, apreciando um momento de cada vez; aceitando as dificuldades como um caminho para a paz; tomando, como Ele fez, este mundo pecaminoso como ele é, não como eu gostaria que fosse; confiando que Ele tornará todas as coisas certas se eu me render à Sua vontade; para que eu possa ser razoavelmente feliz nesta vida e supremamente feliz com Ele para sempre na próxima. Amém.',
    ),
    Prayer(
      title: 'Oração de Gratidão',
      text: 'Pai Celestial, hoje venho diante de Ti com um coração grato. Obrigado por mais um dia de vida, pela saúde, pelo alimento, pelo teto sobre minha cabeça e pelo amor que me cerca. Agradeço pelas bênçãos que reconheço e por aquelas que ainda não percebi. Obrigado pela Tua presença constante, pelo Teu amor incondicional e pela graça que me sustenta a cada momento. Ajuda-me a viver hoje com gratidão em todas as circunstâncias, reconhecendo que tudo o que tenho vem de Ti. Em nome de Jesus, amém.',
    ),
    Prayer(
      title: 'Oração por Sabedoria',
      text: 'Deus de toda sabedoria, venho a Ti reconhecendo minha necessidade de Tua orientação. As decisões que enfrento parecem maiores do que minha capacidade de discernimento. Peço que me concedas a sabedoria que vem do alto - pura, pacífica, amável, compreensiva, cheia de misericórdia e de bons frutos. Que eu possa ver as situações como Tu as vês e responder como Tu responderias. Guia meus pensamentos, palavras e ações para que eu possa honrar-Te em tudo. Confio que Tu me darás liberalmente a sabedoria que peço, sem me censurar. Em nome de Jesus, amém.',
    ),
    Prayer(
      title: 'Oração por Força',
      text: 'Senhor Todo-Poderoso, em Ti está a fonte de toda força. Quando me sinto fraco e incapaz, lembro que posso fazer todas as coisas por meio de Cristo que me fortalece. Hoje, peço que renoves minhas forças como as da águia. Que eu corra e não me canse, que eu ande e não desfaleça. Nas batalhas que enfrento, sê Tu o meu escudo e a minha fortaleza. Ajuda-me a permanecer firme na fé, sabendo que depois que eu tiver sofrido um pouco, Tu mesmo me restaurarás, me confirmará, me fortalecerá e me porás em bases firmes. Em nome de Jesus, amém.',
    ),
    Prayer(
      title: 'Oração pela Família',
      text: 'Pai Celestial, entrego minha família em Tuas mãos amorosas. Protege cada membro com Teu poder, guia-nos com Tua sabedoria e une-nos com Teu amor. Que nosso lar seja um lugar de paz, alegria, compreensão e respeito mútuo. Ajuda-nos a perdoar uns aos outros como Tu nos perdoaste. Que possamos crescer juntos na fé e no amor a Ti. Abençoa nossas conversas, nossos momentos juntos e até mesmo nossos desafios. Que sejamos um reflexo do Teu amor no mundo. Em nome de Jesus, amém.',
    ),
    Prayer(
      title: 'Oração pelo Novo Dia',
      text: 'Senhor, ao despertar para este novo dia, meu primeiro pensamento é de gratidão por Tua fidelidade que se renova a cada manhã. Tuas misericórdias são novas a cada dia. Guia meus passos hoje, ilumina meu caminho com Tua Palavra. Que minhas palavras sejam de edificação, meus pensamentos puros e minhas ações honrosas. Ajuda-me a ver oportunidades para servir, para amar e para compartilhar Tua bondade com aqueles que encontrar. Que este dia seja vivido para Tua glória. Em nome de Jesus, amém.',
    ),
    Prayer(
      title: 'Oração por Cura',
      text: 'Deus de toda consolação, Tu és o Grande Médico que cura todas as enfermidades. Apresento-me diante de Ti, pedindo Tua intervenção curadora em minha vida [ou na vida de quem precisa de cura]. Toca com Teu poder cada célula, cada órgão, cada parte do corpo que necessita de restauração. Que Tua paz inunde a mente e o coração, trazendo cura emocional e espiritual também. Creio que pelo Teu sofrimento fomos curados. Ajuda-me a confiar em Teu tempo perfeito e em Teus caminhos que são mais altos que os meus. Em nome de Jesus, o Senhor que cura, amém.',
    ),
    Prayer(
      title: 'Oração por Direção',
      text: 'Pai Celestial, Tu prometeste dirigir os meus passos se eu confiar em Ti de todo o coração e não me apoiar em meu próprio entendimento. Hoje, busco Tua direção para minha vida. Mostra-me o caminho que devo seguir. Abre as portas que devo atravessar e fecha aquelas que me desviariam do Teu propósito. Dá-me discernimento para reconhecer Tua voz entre tantas outras que clamam por minha atenção. Que eu tenha coragem para seguir onde Tu me guias, mesmo quando o caminho parecer incerto. Confio que Teus planos para mim são de paz e não de mal, para me dar um futuro e uma esperança. Em nome de Jesus, amém.',
    ),
    Prayer(
      title: 'Oração de Arrependimento',
      text: 'Deus misericordioso, venho a Ti com um coração contrito e quebrantado. Reconheço meus pecados e falhas diante de Ti. Pequei em pensamentos, palavras e ações. Fiz o que não devia e deixei de fazer o que devia. Peço Teu perdão pela Tua grande misericórdia. Lava-me completamente da minha iniquidade e purifica-me do meu pecado. Cria em mim um coração puro, ó Deus, e renova um espírito reto dentro de mim. Restaura em mim a alegria da Tua salvação e sustenta-me com um espírito disposto. Agradeço porque, se confessamos nossos pecados, Tu és fiel e justo para nos perdoar e nos purificar de toda injustiça. Em nome de Jesus, amém.',
    ),
  ];

  /// Retorna uma oração aleatória da lista
  static Prayer getRandomPrayer() {
    final random = Random();
    return _prayers[random.nextInt(_prayers.length)];
  }

  /// Retorna uma oração específica pelo índice
  static Prayer getPrayerByIndex(int index) {
    if (index < 0 || index >= _prayers.length) {
      throw ArgumentError('Índice fora dos limites');
    }
    return _prayers[index];
  }

  /// Retorna todas as orações
  static List<Prayer> getAllPrayers() {
    return List.from(_prayers);
  }
} 
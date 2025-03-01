import 'package:flutter/material.dart';
import 'package:jesusapp/chat/chatController.dart';
import 'package:jesusapp/theme/theme_provider.dart';
import 'package:jesusapp/services/verse_service.dart';
import 'dart:math';

class MockAiService implements IApiService {
  final ThemeProvider? themeProvider;
  final Random _random = Random();
  
  MockAiService({this.themeProvider});
  
  @override
  Future<String> getResponse(String message) async {
    // Simular tempo de resposta variável para parecer mais natural
    await Future.delayed(Duration(milliseconds: 500 + _random.nextInt(1500)));
    
    // Verificar se estamos no tema cristão
    final appType = themeProvider?.getConfig<String>('appType', defaultValue: '') ?? '';
    final isChristian = appType == 'christian';
    
    if (isChristian) {
      return _getChristianResponse(message);
    }
    
    return 'Resposta simulada para: $message';
  }
  
  String _getChristianResponse(String message) {
    message = message.toLowerCase();
    
    // Respostas para temas comuns
    if (message.contains('fé') || message.contains('acreditar')) {
      return 'A fé é a certeza daquilo que esperamos e a prova das coisas que não vemos (Hebreus 11:1). Em momentos de dúvida, lembre-se que a fé do tamanho de um grão de mostarda pode mover montanhas. Cultive sua fé através da oração, da leitura da Palavra e da comunhão com outros cristãos.\n\nJesus nos ensina: "Tudo é possível àquele que crê" (Marcos 9:23).';
    }
    
    if (message.contains('oração') || message.contains('rezar') || message.contains('como orar')) {
      return 'A oração é nossa comunicação direta com Deus. Jesus nos ensinou a orar no Pai Nosso (Mateus 6:9-13). Ore com sinceridade, gratidão e confiança. "Não andem ansiosos por coisa alguma, mas em tudo, pela oração e súplicas, e com ação de graças, apresentem seus pedidos a Deus" (Filipenses 4:6).\n\nLembre-se também que o Espírito Santo intercede por nós: "Da mesma forma o Espírito nos ajuda em nossa fraqueza, pois não sabemos como orar, mas o próprio Espírito intercede por nós com gemidos inexprimíveis" (Romanos 8:26).';
    }
    
    if (message.contains('perdão') || message.contains('perdoar')) {
      return 'O perdão é central no cristianismo. Jesus nos ensinou a perdoar "setenta vezes sete" (Mateus 18:22). Perdoar não significa esquecer ou negar o mal, mas escolher libertar-se do ressentimento. "Sejam bondosos e compassivos uns para com os outros, perdoando-se mutuamente, assim como Deus perdoou vocês em Cristo" (Efésios 4:32).\n\nNa cruz, Jesus demonstrou o perdão supremo ao dizer: "Pai, perdoa-lhes, pois não sabem o que estão fazendo" (Lucas 23:34).';
    }
    
    if (message.contains('amor') || message.contains('amar')) {
      return 'O amor é o maior mandamento. Jesus disse: "Ame o Senhor, seu Deus, de todo o seu coração, de toda a sua alma e de todo o seu entendimento. Este é o primeiro e maior mandamento. E o segundo é semelhante a ele: Ame o seu próximo como a si mesmo" (Mateus 22:37-39).\n\nO apóstolo Paulo nos dá uma bela descrição do amor em 1 Coríntios 13:4-7: "O amor é paciente, o amor é bondoso. Não inveja, não se vangloria, não se orgulha. Não maltrata, não procura seus interesses, não se ira facilmente, não guarda rancor. O amor não se alegra com a injustiça, mas se alegra com a verdade. Tudo sofre, tudo crê, tudo espera, tudo suporta."';
    }
    
    if (message.contains('esperança') || message.contains('esperar')) {
      return 'A esperança cristã não é um desejo incerto, mas uma expectativa confiante baseada nas promessas de Deus. "Que o Deus da esperança os encha de toda alegria e paz, por sua confiança nele, para que vocês transbordem de esperança, pelo poder do Espírito Santo" (Romanos 15:13).\n\nNossa esperança está firmada na ressurreição de Cristo: "Bendito seja o Deus e Pai de nosso Senhor Jesus Cristo! Conforme a sua grande misericórdia, ele nos regenerou para uma esperança viva, por meio da ressurreição de Jesus Cristo dentre os mortos" (1 Pedro 1:3).';
    }
    
    if (message.contains('paz') || message.contains('tranquilidade') || message.contains('ansiedade')) {
      return '"Deixo-lhes a paz; a minha paz lhes dou. Não a dou como o mundo a dá. Não se perturbe o seu coração, nem tenham medo" (João 14:27). A paz de Cristo transcende as circunstâncias e nos sustenta mesmo nas tempestades da vida.\n\nQuando sentir ansiedade, lembre-se: "Lancem sobre ele toda a sua ansiedade, porque ele tem cuidado de vocês" (1 Pedro 5:7). E "a paz de Deus, que excede todo o entendimento, guardará o coração e a mente de vocês em Cristo Jesus" (Filipenses 4:7).';
    }
    
    if (message.contains('bíblia') || message.contains('escritura') || message.contains('palavra')) {
      return 'A Bíblia é a Palavra inspirada de Deus, "útil para ensinar, repreender, corrigir e treinar na justiça" (2 Timóteo 3:16). Através dela, Deus revela seu caráter, sua vontade e seu plano de redenção.\n\n"A tua palavra é lâmpada para os meus pés e luz para o meu caminho" (Salmos 119:105). Dedique tempo diariamente para ler, meditar e aplicar as Escrituras em sua vida, pois "nem só de pão viverá o homem, mas de toda palavra que procede da boca de Deus" (Mateus 4:4).';
    }
    
    if (message.contains('graça') || message.contains('salvação')) {
      return '"Pois vocês são salvos pela graça, por meio da fé, e isto não vem de vocês, é dom de Deus; não por obras, para que ninguém se glorie" (Efésios 2:8-9). A graça é o favor imerecido de Deus, seu amor e misericórdia oferecidos livremente a nós em Cristo Jesus.\n\n"Porque Deus amou o mundo de tal maneira que deu o seu Filho unigênito, para que todo aquele que nele crê não pereça, mas tenha a vida eterna" (João 3:16). Esta é a essência do evangelho - a boa notícia da graça salvadora de Deus.';
    }
    
    if (message.contains('sofrimento') || message.contains('dor') || message.contains('dificuldade') || message.contains('problema')) {
      return 'O sofrimento é uma realidade neste mundo caído, mas Deus promete estar conosco em meio à dor. "Mesmo quando eu andar por um vale de trevas e morte, não temerei perigo algum, pois tu estás comigo; a tua vara e o teu cajado me protegem" (Salmos 23:4).\n\nPaulo nos lembra que "os sofrimentos do tempo presente não podem ser comparados com a glória que em nós será revelada" (Romanos 8:18). E Tiago nos encoraja: "Considerem motivo de grande alegria o fato de passarem por diversas provações, pois vocês sabem que a prova da sua fé produz perseverança" (Tiago 1:2-3).';
    }
    
    if (message.contains('propósito') || message.contains('vontade de deus') || message.contains('plano')) {
      return 'Deus tem um propósito para sua vida. "Porque sou eu que conheço os planos que tenho para vocês, diz o Senhor, planos de fazê-los prosperar e não de causar dano, planos de dar a vocês esperança e um futuro" (Jeremias 29:11).\n\nBusque a vontade de Deus em oração e na Palavra: "Não se amoldem ao padrão deste mundo, mas transformem-se pela renovação da sua mente, para que sejam capazes de experimentar e comprovar a boa, agradável e perfeita vontade de Deus" (Romanos 12:2).';
    }
    
    if (message.contains('igreja') || message.contains('comunidade') || message.contains('comunhão')) {
      return 'A igreja é o corpo de Cristo, e cada crente é um membro desse corpo (1 Coríntios 12:27). A comunhão com outros cristãos é essencial para nosso crescimento espiritual. "Não deixemos de reunir-nos como igreja, segundo o costume de alguns, mas encorajemo-nos uns aos outros" (Hebreus 10:25).\n\nNa igreja primitiva, "eles se dedicavam ao ensino dos apóstolos e à comunhão, ao partir do pão e às orações" (Atos 2:42). Busque uma comunidade onde você possa crescer na fé, servir com seus dons e experimentar o amor fraternal.';
    }
    
    if (message.contains('espírito santo') || message.contains('espírito de deus')) {
      return 'O Espírito Santo é Deus presente em nós, nosso Consolador e Guia. Jesus prometeu: "Mas o Consolador, o Espírito Santo, que o Pai enviará em meu nome, lhes ensinará todas as coisas e lhes fará lembrar tudo o que eu lhes disse" (João 14:26).\n\nO Espírito produz em nós seu fruto: "amor, alegria, paz, paciência, amabilidade, bondade, fidelidade, mansidão e domínio próprio" (Gálatas 5:22-23). Busque ser cheio do Espírito (Efésios 5:18) e sensível à sua direção em sua vida.';
    }
    
    if (message.contains('adoração') || message.contains('louvor') || message.contains('adorar')) {
      return 'A adoração é nossa resposta ao amor e à grandeza de Deus. "Adorem ao Senhor com alegria; entrem na sua presença com cânticos alegres" (Salmos 100:2). A verdadeira adoração envolve todo o nosso ser - coração, mente, alma e forças.\n\nJesus ensinou que "os verdadeiros adoradores adorarão o Pai em espírito e em verdade. São estes os adoradores que o Pai procura" (João 4:23). A adoração não se limita a momentos específicos ou lugares, mas é um estilo de vida de glorificar a Deus em tudo o que fazemos.';
    }
    
    // Adicionar um versículo aleatório para enriquecer a resposta
    if (_random.nextBool() && !message.contains('versículo')) {
      final verse = VerseService.getRandomVerse();
      return _getGenericResponse(message) + '\n\nGostaria de compartilhar este versículo com você: "${verse.text}" - ${verse.reference}';
    }
    
    // Resposta para pedido específico de versículo
    if (message.contains('versículo') || message.contains('verso bíblico')) {
      final verse = VerseService.getRandomVerse();
      return 'Aqui está um versículo para sua reflexão: "${verse.text}" - ${verse.reference}\n\nQue a Palavra de Deus ilumine seu caminho e fortaleça sua fé hoje.';
    }
    
    // Resposta genérica para outras perguntas
    return _getGenericResponse(message);
  }
  
  String _getGenericResponse(String message) {
    final List<String> responses = [
      'Essa é uma reflexão importante. A Palavra nos ensina que devemos "examinar tudo e reter o que é bom" (1 Tessalonicenses 5:21). Busque a sabedoria em oração e na leitura das Escrituras.',
      
      'Lembre-se que "o temor do Senhor é o princípio da sabedoria" (Provérbios 9:10). Continue buscando a Deus de todo o coração, pois Ele promete: "Vocês me procurarão e me acharão quando me procurarem de todo o coração" (Jeremias 29:13).',
      
      'Jesus nos convida: "Venham a mim, todos os que estão cansados e sobrecarregados, e eu lhes darei descanso" (Mateus 11:28). Leve suas questões a Ele em oração, confiando em sua sabedoria e amor.',
      
      'A Palavra de Deus é "viva e eficaz, e mais afiada que qualquer espada de dois gumes" (Hebreus 4:12). Busque nela orientação para suas perguntas, meditando dia e noite em seus ensinamentos.',
      
      'Como cristãos, somos chamados a crescer "na graça e no conhecimento de nosso Senhor e Salvador Jesus Cristo" (2 Pedro 3:18). Que o Espírito Santo o guie em toda a verdade enquanto você busca respostas.',
    ];
    
    return responses[_random.nextInt(responses.length)];
  }
}